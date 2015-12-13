#from http://stackoverflow.com/questions/34047103/estimating-dacay-constant-with-jags
#seems to work 

set.seed(123)

N = 1000;

sigma = 0.1;
beta  = c(0.75,0.33)
tau   = c(5.7,1.3)

X<-cbind(rnorm(N,1,1),rnorm(N,2,1))
t<-cbind(rnorm(N,1,1),rnorm(N,2,1))
t = abs(t);
tt <- matrix(data=NA, nrow=dim(t)[1], ncol=dim(t)[2])
 for(i in 1:dim(t)[1]){
   tt[i,] <- t[i,]/tau
 }


####JAGS
##################
library(mcmcplots)
library(runjags)
library(rjags)


modelstring = "
model{
  for( j in 1:N ){
    for(i in 1:p){
      td[j,i] <- exp( - t[j,i] / Tau[i] )
    }

   mu[j] <- inprod( X[j,]*td[j,] ,beta[] )
    Y[j] ~ dnorm( mu[j], sigma )
  }

  for(j in 1:p){
    bsigma[j] ~dgamma(0.001,0.001);
    beta[j] ~ dnorm(0,bsigma[j]);
    Tau[j] ~ dgamma(0.001,0.001);
  }
  sigma  ~ dgamma(0.001,0.001)
}"

########

jags_data <- list(Y = tt[,1],
              t = t,
              X = X,
              p = ncol(X),
              N=nrow(X)
              )
params <- c( "Tau",'sigma','beta')
adapt <- 1000
burn <- 1000
iterations <- 1000

sample <- jags.model(textConnection(modelstring),
  data=jags_data, n.chains=2)

update(sample, burn) # Burning some samples to the MCMC gods....

# The parameters to monitor.
params <- c("beta", "Tau", "mu", "bsigma")
samples <- coda.samples(sample, params, n.iter = iterations)
