
##########################
library(rjags)

#------------------------------------------------------------------------------
# THE DATA.

#create preliminary data for the prior of the power calculation

set.seed(1)

tx1 = rnorm(20, 3, 2)
tx2 = rnorm(20, 1.5, 2)
mean(tx2 - tx1)

y = c(tx1, tx2)
group = c(rep(1, length(tx1)), rep(2, length(tx2)))

N = length(y)
dataList = list(
  y = y ,
  group = group,
  Ncond = length(unique(group)),
  N = N
)

#------------------------------------------------------------------------------
# THE MODEL.

model_string = "
model {
  for ( i in 1:N ) {
    y[i] ~ dnorm( mu[group[i]] , sigma[group[i]])
  }
  for( j in 1:Ncond ){
    mu[j] ~ dnorm(mu_mu_hyper, 3)
    sigma[j] ~ dnorm(sigma_mu_hyper, 6)
  }
  mu_mu_hyper ~ dnorm(2, 3)
  sigma_mu_hyper ~ dnorm(3, 6)
}"

##########################
# run jags

jagsModel = jags.model( textConnection(model_string) , data=dataList ,
                        n.chains=4 , n.adapt=1000 )

cat( "Burning in the MCMC chain...\n" )
update( jagsModel , n.iter = 500 )
# The saved MCMC chain:
parameters = c("mu", "sigma", "mu_mu_hyper", "sigma_mu_hyper")


cat( "Sampling final MCMC chain...\n" )
codaSamples = coda.samples( jagsModel , variable.names=parameters ,
                            n.iter=1000 , thin = 10 )

summary(codaSamples)

#
#
# #------------------------------------------------------------------------------
# # INTIALIZE THE CHAINS.
#
# # Specific initialization is not necessary in this case,
# # but here is a lazy version if wanted:
# # initsList = list( theta1=0.5 , theta2=0.5 , m=1 )
#
# #------------------------------------------------------------------------------
# # RUN THE CHAINS.
#
# parameters = c("m","theta1","theta2")
# adaptSteps = 1000            # Number of steps to "tune" the samplers.
# burnInSteps = 1000           # Number of steps to "burn-in" the samplers.
# nChains = 4                  # Number of chains to run.
# numSavedSteps=10000          # Total number of steps in chains to save.
# thinSteps=1                  # Number of steps to "thin" (1=keep every step).
# nPerChain = ceiling( ( numSavedSteps * thinSteps ) / nChains ) # Steps per chain.
# # Create, initialize, and adapt the model:
# jagsModel = jags.model( "TEMPmodel.txt" , data=dataList , # inits=initsList ,
#                         n.chains=nChains , n.adapt=adaptSteps )
# # Burn-in:
# cat( "Burning in the MCMC chain...\n" )
# update( jagsModel , n.iter=burnInSteps )
# # The saved MCMC chain:
#
#
# cat( "Sampling final MCMC chain...\n" )
# codaSamples = coda.samples( jagsModel , variable.names = parameters ,
#                             n.iter=nPerChain , thin=thinSteps )
# # resulting codaSamples object has these indices:
# #   codaSamples[[ chainIdx ]][ stepIdx , paramIdx ]
#
# save( codaSamples , file=paste0(fileNameRoot,"Mcmc.Rdata") )
