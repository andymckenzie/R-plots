#copying from http://www.sumsar.net/blog/2014/03/bayesian-first-aid-pearson-correlation-test/

set.seed(42)

##########
# load the data for trait correlation

## Model code for the Bayesian First Aid alternative to Pearson's correlation test. ##
library(rjags)

nvars = 2
nobs = 1000

#code for simulation from http://www.r-bloggers.com/simulating-random-multivariate-correlated-data-continuous-variables/
R = matrix(cbind(1,.9,.2,  .75,1,.7,  .2,.5,1),nrow=3)
U = t(chol(R))
nvars = dim(U)[1]
numobs = 100000
set.seed(1)
random.normal = matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
X = U %*% random.normal
X = t(X[c(1:nvars), c(1:nobs)])

R = matrix(cbind(1,.4,.2,  .2,1,.1,  .2,.4,1),nrow=3)
U = t(chol(R))
nvars = dim(U)[1]
numobs = 100000
set.seed(1)
random.normal = matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
Y = U %*% random.normal
Y = t(Y[c(1:nvars), c(1:nobs)])

R = matrix(cbind(1,.8,.2,  .5,6,.1,  .2,.8,1),nrow=3)
U = t(chol(R))
nvars = dim(U)[1]
numobs = 100000
set.seed(1)
random.normal = matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
Z = U %*% random.normal
Z = t(Z[c(1:nvars), c(1:nobs)])

# Setting up the data
x <- c(X[,1], Y[,1], Z[,1])
y <- c(X[,2], Y[,2], Z[,2])
group <- c(rep("1", length = nobs), rep("2", length = nobs),
  rep("3", length = nobs))
xy <- cbind(x, y, group)

# The model string written in the JAGS language
model_string <- "model {
  for(i in 1:n) {
    xy[i,1:2] ~ dmt(mu[,group[i]], prec[,,group[i]], nu)
  }

	for(j in 1:nCond){
	  cov[1,1,j] <- sigma[1] * sigma[1]
	  cov[1,2,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,1,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,2,j] <- sigma[2] * sigma[2]
	  rho[j] ~ dunif(-0.5, 0.5)
	  mu[1,j] ~ dnorm(mean_mu, precision_mu)
	  mu[2,j] ~ dnorm(mean_mu, precision_mu)
    # JAGS parameterizes the multivariate t using precision (inverse of variance)
    # rather than variance, therefore we must invert the covariance matrices.
    prec[1:2,1:2,j] <- inverse(cov[,,j])
	}

  ## Priors
  sigma[1] ~ dunif(sigmaLow, sigmaHigh)
  sigma[2] ~ dunif(sigmaLow, sigmaHigh)
  nu <- nuMinusOne+1
  nuMinusOne ~ dexp(1/29)
}"

# Initializing the data list and setting parameters for the priors
# that in practice will result in flat priors on mu and sigma.
data_list = list(
  xy = cbind(x, y),
  n = length(x),
  group = group,
  nCond = nvars,
  mean_mu = mean(c(x, y), trim=0.2) ,
  mean_rho = 1,
  precision_rho = 0.0001,
  precision_mu = 1 / (max(mad(x), mad(y))^2 * 1000000),
  sigmaLow = max(mad(x), mad(y)) / 1000 ,
  sigmaHigh = min(mad(x), mad(y)) * 1000)

# Initializing parameters to sensible starting values helps the convergence
# of the MCMC sampling. Here using robust estimates of the mean (trimmed)
# and standard deviation (MAD).
inits_list = list(mu=c(mean(x, trim=0.2), mean(y, trim=0.2)), rho=cor(x, y, method="spearman"),
                sigma = c(mad(x), mad(y)), nuMinusOne = 5)

# The parameters to monitor.
params <- c("rho", "mu", "sigma", "nu")

# Running the model
#inits = inits_list,
model <- jags.model(textConnection(model_string), data = data_list,
                    n.chains = 3, n.adapt=1000)
update(model, 500) # Burning some samples to the MCMC gods....
samples <- coda.samples(model, params, n.iter=5000)

# Inspecting the posterior
plot(samples)
summary(samples)
