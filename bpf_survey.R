library(ggplot2)
library(dplyr)

results_file = "/Users/amckenz/Documents/bpf_survey/Batch_1950191_batch_results.csv"
data_columns_start = 24
data_columns_end = 48

res = read.table(file = results_file, sep = ",", header = T, fill = T)

res_only = res[ , c(data_columns_start:data_columns_end)]

#analyses to do: 
#summary statistics of the BP questions
#statistcs of the BP questions segregated by demo variables
#linear models to predict responses based on the demo variables 
#correlations among all of the variables (just throw turn them into factors and throw it into a covariance matrix...)

#plot(res_only$Answer.Age, res_only$Answer.ProbBP)

#build a linear model of the demographic variables to predict whether they could imagine electing to do it ... (or one of the other key response variables)



prob_BP = as.numeric(gsub("%", "", res_only$Answer.ProbBP))

a = lm(prob_BP ~ res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Health + res_only$Answer.Afterlife)

Imagine_Nums = as.numeric(factor(res_only$Answer.Imagine, 
	levels = c("No", "LikelyNo", "Unsure", "LikelyYes", "Yes")))
	
b = lm(Imagine_Nums ~ res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Health + res_only$Answer.Afterlife)