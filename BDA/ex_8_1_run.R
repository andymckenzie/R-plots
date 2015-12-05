library(rjags)

###################################
# create data for simulation 
coin1 = rbinom(10, size = 1, prob = 0.1)
coin2 = rbinom(20, size = 1, prob = 0.4)
# coin3 = rbinom(20, size = 1, prob = 0.8)
# coin4 = rbinom(5, size = 1, prob = 0.85) #expecting this one to be shrunken towards the mean more

y = c(coin1, coin2 
	# ,coin3, coin4
	)
s = c(rep("coin1", times = length(coin1)), 
	rep("coin2", times = length(coin2)) 
	# ,rep("coin3", times = length(coin3)),
	# rep("coin4", times = length(coin4))
	)
	
data = data.frame(y, s)
colnames(data) = c("y", "s")

#####################################
# prep data for loading into JAGS
data$s = as.factor(data$s)

y = data$y
s = as.numeric(data$s) # converts character to consecutive integer levels

if ( any( y!=0 & y!=1 ) ) { stop("All y values must be 0 or 1.") }
dataList = list(
	y = y ,
	s = s ,
	Ntotal = length(y) ,
	Nsubj = length(unique(s)))
#-----------------------------------------------------------------------------
# THE MODEL.
modelString = "
model {
for ( i in 1:Ntotal ) {
  y[i] ~ dbern( theta[s[i]] ) #nested indexing for correct theta on each loop 
}
#need to change the variable name per this very useful answer: http://stackoverflow.com/a/33474530/560791
for ( subj in 1:Nsubj ) { 
  theta[subj] ~ dbeta( 2 , 2 ) # N.B.: 2,2 prior; change as appropriate.
}
}
" # close quote for modelString
writeLines( modelString , con="TEMPmodel.txt" )

jagsModel = jags.model( "TEMPmodel.txt" , data=dataList , 
                      n.chains=4 , n.adapt=500 )

initsList = function() {
thetaInit = rep(0,Nsubj)
for ( sIdx in 1:Nsubj ) { # for each subject
  includeRows = ( s == sIdx ) # identify rows of this subject
  yThisSubj = y[includeRows]  # extract data of this subject
  resampledY = sample( yThisSubj , replace=TRUE ) # resample
  thetaInit[sIdx] = sum(resampledY)/length(resampledY)
}
thetaInit = 0.001+0.998*thetaInit # keep away from 0,1
return( list( theta=thetaInit ) )
}

numSavedSteps=50000
parameters = c( "theta")     # The parameters to be monitored
adaptSteps = 500             # Number of steps to adapt the samplers
burnInSteps = 500            # Number of steps to burn-in the chains
nChains = 4                  # nChains should be 2 or more for diagnostics
thinSteps = 1
nIter = ceiling( ( numSavedSteps * thinSteps ) / nChains )
# Create, initialize, and adapt the model:
# jagsModel = jags.model( "TEMPmodel.txt" , data=dataList ,
#                       n.chains=nChains , n.adapt=adaptSteps )
cat( "Burning in the MCMC chain...\n" )
update( jagsModel , n.iter=burnInSteps )
# The saved MCMC chain:
cat( "Sampling final MCMC chain...\n" )
codaSamples = coda.samples( jagsModel , variable.names=parameters , 
                          n.iter=nIter , thin=thinSteps )

