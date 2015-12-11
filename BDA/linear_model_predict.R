#from http://stackoverflow.com/questions/33662987/fit-a-bayesian-linear-regression-and-predict-unobservable-values
#seems like it should be pretty easy to go from this to group-wide linear regression

library(rjags)
# Simulate data (100 observations)
my.data <- as.data.frame(matrix(data=NA, nrow=100, ncol=2))
names(my.data) <- c("X", "Y")
# the linear model will predict Y based on the covariate X

my.data$X <- runif(100) # values for the covariate
int <- 2     # specify the true intercept
slope <- 1   # specify the true slope
sigma <- .5   # specify the true residual standard deviation
my.data$Y <- rnorm(100, slope*my.data$X+int, sigma)  # Simulate the data

#### Extra data for prediction of unknown Y-values from known X-values
y.predict <- as.data.frame(matrix(data=NA, nrow=5, ncol=2))
names(y.predict) <- c("X", "Y")
y.predict$X <- c(-1, 0, 1.3, 2, 7)

mydata <- rbind(my.data, y.predict)

set.seed(333)
model_string <- "model{

  # Priors

  int ~ dnorm(0, .001)
  slope ~ dnorm(0, .001)
  tau <- 1/(sigma * sigma)
  sigma ~ dunif(0,10)

  # Model structure

  for(i in 1:R){
    Y[i] ~ dnorm(m[i],tau)
    m[i] <- int + slope * X[i]
  }

}"

jags.data <- list(R=dim(mydata)[1], X=mydata$X, Y=mydata$Y)

inits <- function(){list(int=rnorm(1, 0, 5), slope=rnorm(1,0,5),
                         sigma=runif(1,0,10))}

params <- c("Y", "int", "slope", "sigma")

nc <- 3
n.adapt <-1000
n.burn <- 1000
n.iter <- 10000
thin <- 10
my.model <- jags.model(textConnection(model_string), data = jags.data,
  inits=inits, n.chains=nc, n.adapt=n.adapt)
update(my.model, n.burn)
my.model_samples <- coda.samples(my.model,params,n.iter=n.iter, thin=thin)
summary(my.model_samples[, c("Y[101]", "Y[102]", "Y[103]", "Y[104]", "Y[105]")])
