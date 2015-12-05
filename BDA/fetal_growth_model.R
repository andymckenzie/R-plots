#following from http://bendixcarstensen.com/Bayes/Cph-2012/pracs.pdf

library(rjags)
library(lme4)

######################
#reading data 

fetal = read.csv("http://BendixCarstensen.com/Bayes/Cph-2012/data/fetal.csv",
	header=TRUE)
	
#####################
# model for initializing parameters	
	
m0 = lmer(sqrt(hc) ~ tga + (1|id), data=fetal )

sigma.e = attr(VarCorr(m0),"sc") 
sigma.u = attr(VarCorr(m0)$id,"stddev")
beta = fixef( m0 )

fetal.ini = list(list(sigma.e = sigma.e/3,
	sigma.u = sigma.u/3,
	beta = beta /3 ),
	list( sigma.e = sigma.e*3,
	sigma.u = sigma.u*3,
	beta = beta *3 ),
	list( sigma.e = sigma.e/3,
	sigma.u = sigma.u*3,
	beta = beta /3 ),
	list( sigma.e = sigma.e*3,
	sigma.u = sigma.u/3,
	beta = beta *3 ) )

########################
# preparing data for JAGS 

fetal.dat = list(id = as.integer(factor(fetal$id)),
	hc = fetal$hc,
	tga = fetal$tga,
	N = nrow(fetal),
	I = length(unique(fetal$id)))

########################
# JAGS model; switching to the textConnection trick 

model_string = "
	model{
	# The model for each observational unit
	for( j in 1:N ){
		mu[j] = beta[1] + beta[2] * ( tga[j]-18 ) + u[id[j]]
		hc[j] ~ dnorm( mu[j], tau.e )
	}

	# Random effects for each person
	for( i in 1:I ){
		u[i] ~ dnorm(0,tau.u)
	}

	# Priors:

	# Fixed intercept and slope
	beta[1] ~ dnorm(0.0,1.0E-5)
	beta[2] ~ dnorm(0.0,1.0E-5)

	# Residual variance
	tau.e = pow(sigma.e,-2)
	sigma.e ~ dunif(0,100)

	# Between-person variation
	tau.u = pow(sigma.u,-2)
	sigma.u ~ dunif(0,100)
}"

system.time(
	fetal.mod <- jags.model( textConnection(model_string),
	data = fetal.dat,
	n.chains = 4,
	inits = fetal.ini,
	n.adapt = 100))
	
system.time(
	 fetal.res <- coda.samples( fetal.mod,
	var = c("beta","sigma.e","sigma.u"),
	n.iter = 500,
	thin = 5 ) )

#for diagnostics, use the below
#plot( fetal.res )
	
#need to get more data from the chain before this is plottable by eg switching the "thin" parameter	
gelman.plot(fetal.res)
	
	
	
	
	
	
	
	
	
	
	
	
	
