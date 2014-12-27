# forked from Trevor Stephens 

# Set working directory and import datafiles
train <- read.csv("/Users/amckenz/Dropbox/kaggle/titanic/train.csv")
test <- read.csv("/Users/amckenz/Dropbox/kaggle/titanic/test.csv")

# Install and load required packages for decision trees and forests
library(rpart)
library(randomForest)
library(party)

# Join together the test and train sets for easier feature engineering
test$Survived <- NA
combi <- rbind(train, test)

# Convert to a string
combi$Name <- as.character(combi$Name)

# Engineered variable: Title
combi$Title <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
combi$Title <- sub(' ', '', combi$Title)
# Combine small title groups
combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
# Convert to a factor
combi$Title <- factor(combi$Title)

# Engineered variable: Family size
combi$FamilySize <- combi$SibSp + combi$Parch + 1

# Engineered variable: Family
combi$Surname <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep="")
combi$FamilyID[combi$FamilySize <= 2] <- 'Small'
# Delete erroneous family IDs
famIDs <- data.frame(table(combi$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
# Convert to a factor
combi$FamilyID <- factor(combi$FamilyID)

# Fill in Age NAs
summary(combi$Age)
Agefit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize, 
                data=combi[!is.na(combi$Age),], method="anova")
combi$Age[is.na(combi$Age)] <- predict(Agefit, combi[is.na(combi$Age),])
# Check what else might be missing
summary(combi)
# Fill in Embarked blanks
summary(combi$Embarked)
which(combi$Embarked == '')
combi$Embarked[c(62,830)] = "S"
combi$Embarked <- factor(combi$Embarked)
# Fill in Fare NAs
summary(combi$Fare)
which(is.na(combi$Fare))
#median imputation 
combi$Fare[1044] <- median(combi$Fare, na.rm=TRUE)

# New factor for Random Forests, only allowed <32 levels, so reduce number
combi$FamilyID2 <- combi$FamilyID
# Convert back to string
combi$FamilyID2 <- as.character(combi$FamilyID2)
combi$FamilyID2[combi$FamilySize <= 3] <- 'Small'
# And convert back to factor
combi$FamilyID2 <- factor(combi$FamilyID2)

# Split back into test and train sets
train <- combi[1:891,]
test <- combi[892:1309,]

####RF Ensemble
# # Build Random Forest Ensemble
# set.seed(415)
# fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID2,
#                     data=train, importance=TRUE, ntree=2000)
# # Look at variable importance
# varImpPlot(fit)
# # Now let's make a prediction and write a submission file
# Prediction <- predict(fit, test)
# submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
# write.csv(submit, file = "/Users/amckenz/Dropbox/kaggle/titanic/firstforest.csv", row.names = FALSE)
#
# # Build condition inference tree Random Forest
# set.seed(415)
# fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
#                data = train, controls=cforest_unbiased(ntree=2000, mtry=3))
# # Now let's make a prediction and write a submission file
# Prediction <- predict(fit, test, OOB=TRUE, type = "response")
# submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
# write.csv(submit, file = "/Users/amckenz/Dropbox/kaggle/titanic/ciforest.csv", row.names = FALSE)

#columns to use for prediction 
#train[,c(3,5,6,7,8,10,12,13,14,16)]

impVarsIndex = c(3,5,6,7,8,10,12,13,14,16)

### Try H2o ####
# The following two commands remove any previously installed H2O packages for R.
# if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
# if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }
#
# # Next, we download, install and initialize the H2O package for R.
# install.packages("h2o", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-markov/1/R", getOption("repos"))))
library(h2o)

## Start a local cluster with 7 cores and 12GB RAM
localH2O = h2o.init(max_mem_size = '6g', nthreads = 4)

## Convert data into H2O
#tnTrain and tnTest are my own personal data frames
h2o_train <- as.h2o(localH2O, train, key = 'dat_train')
h2o_test <- as.h2o(localH2O, test, key = 'dat_test')

#You can also import data directly
## Import MNIST CSV as H2O
#dat_h2o <- h2o.importFile(localH2O, path = ".../mnist_train.csv")

h2oDNN <-
h2o.deeplearning(x = impVarsIndex, # column numbers for predictors
y = 2, # column number for label
data = h2o_train, # data in H2O format
classification = TRUE,
autoencoder = FALSE,
activation = "RectifierWithDropout", #There are several options here
input_dropout_ratio = 0.1, # % of inputs dropout
hidden_dropout_ratios = c(0.5,0.5,0.5), # % for nodes dropout
l2=.0005, #l2 penalty for regularization
seed=5,
hidden = c(300,300,300), # three layers of 300 nodes
variable_importances=TRUE,
epochs = 30) # max. no. of epochs

## Using the DNN model for predictions
dnnPred6 <- h2o.predict(h2oDNN, h2o_test)
#.3653,.3659,.3702,3712,3695
## Converting H2O format into data frame
dnnPred6 <- as.data.frame(dnnPred6)

#h2osubmit = cbind(submit, dnnPred6)
#h2o_submit_only = h2osubmit[,c(1,3)]
#names(h2o_submit_only) = c("PassengerID", "Survived")
#write.csv(submit, file = "/Users/amckenz/Dropbox/kaggle/titanic/h2o_prediction.csv", row.names = FALSE)