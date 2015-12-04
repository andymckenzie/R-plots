#exercise 2.7; LMM; from http://bendixcarstensen.com/Bayes/Cph-2012/pracs.pdf

library(rjags)
library(lme4)

######################
#reading data 

fetal = read.csv("http://BendixCarstensen.com/Bayes/Cph-2012/data/fetal.csv",
	header=TRUE)
	
#####################
# model for initializing parameters	
	
# m0 = lmer( hc ~ tga + (tga|id), data=fetal )
#
# sigma.u = as.matrix( VarCorr( m0 )$id )
# sigma.b = as.matrix( vcov( m0 ) )
# sigma.e = attr( VarCorr(m0), "sc" )
#
# fetal.ini = list(list(sigma.e = sigma.e/3,
# 	sigma.u = sigma.u/3,
# 	beta = beta /3 ),
# 	list( sigma.e = sigma.e*3,
# 	sigma.u = sigma.u*3,
# 	beta = beta *3 ),
# 	list( sigma.e = sigma.e/3,
# 	sigma.u = sigma.u*3,
# 	beta = beta /3 ),
# 	list( sigma.e = sigma.e*3,
# 	sigma.u = sigma.u/3,
# 	beta = beta *3 ) )


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
	# Fixing data to be used in model definition
	data
	{
	zero[1] <- 0
	zero[2] <- 0
	R[1,1] <- 0.1
	R[1,2] <- 0
	R[2,1] <- 0
	R[2,2] <- 0.5
	}
	# Then define model
	model
	{
	# Intercept and slope for each person, including random effects
	for( i in 1:I )
	{
	u[i,1:2] ~ dmnorm(zero,Omega.u)
	}

	# Define model for each observational unit
	for( j in 1:N )
	{
	mu[j] <- ( beta[1] + u[id[j],1] ) +
	( beta[2] + u[id[j],2] ) * ( tga[j]-18 )
	hc[j] ~ dnorm( mu[j], tau.e )
	}

	#------------------------------------------------------------
	# Priors:

	# Fixed intercept and slope
	beta[1] ~ dnorm(0.0,1.0E-5)
	beta[2] ~ dnorm(0.0,1.0E-5)

	# Residual variance
	tau.e <- pow(sigma.e,-2)
	sigma.e ~ dunif(0,100)

	# Define prior for the variance-covariance matrix of the random effects
	Sigma.u <- inverse(Omega.u)
	Omega.u ~ dwish( R, 2 )
	}"
	

system.time(
	fetal.mod <- jags.model( textConnection(model_string),
	data = fetal.dat,
	n.chains = 4,
	n.adapt = 100))
	
system.time(
	 fetal.res <- coda.samples( fetal.mod,
	var = c("beta","sigma.e", "Sigma.u"),
	n.iter = 500,
	thin = 5 ) )

#for diagnostics, use the below
#plot( fetal.res )
	
