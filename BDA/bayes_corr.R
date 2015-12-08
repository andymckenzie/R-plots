#copying from http://www.sumsar.net/blog/2014/03/bayesian-first-aid-pearson-correlation-test/

##########
# load the data for trait correlation 
#simulate data for now 



## Model code for the Bayesian First Aid alternative to Pearson's correlation test. ##
require(rjags)

# Setting up the data
x <- exposure_to_puppies
y <- rated_happieness
xy <- cbind(x, y)

# The model string written in the JAGS language
model_string <- "model {
  for(i in 1:n) {
    xy[i,1:2,j] ~ dmt(mu[,j], prec[ , ,j], nu) 
  }

  # JAGS parameterizes the multivariate t using precision (inverse of variance) 
  # rather than variance, therefore here inverting the covariance matrix.

	for(j in 1:nCond){
	  cov[1,1,j] <- sigma[1] * sigma[1]
	  cov[1,2,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,1,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,2,j] <- sigma[2] * sigma[2]
	  rho ~ dunif(-1, 1)
	  mu[1] ~ dnorm(mean_mu[j], precision_mu[j])
	  mu[2] ~ dnorm(mean_mu[j], precision_mu[j])
    prec[1:2,1:2,j] <- inverse(cov[,])
	}
	#means of the rhos are drawn from a normal distribution
  # Constructing the covariance matrix

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
  mean_mu = mean(c(x, y), trim=0.2) ,
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
model <- jags.model(textConnection(model_string), data = data_list,
                    inits = inits_list, n.chains = 3, n.adapt=1000)
update(model, 500) # Burning some samples to the MCMC gods....
samples <- coda.samples(model, params, n.iter=5000)

# Inspecting the posterior
plot(samples)
summary(samples)