#model of fantasy success for each team thus far 
#inspired by http://www.ling.uni-potsdam.de/~vasishth/JAGSStanTutorial/SorensenVasishthMay12014.pdf

library(rjags)
library(reshape2)

data = read.csv("/Users/amckenz/Documents/github/FantasyFootball/FFStats.csv")

data$ID = 1:length(data$Owner)

datam = data[ , c("ID", paste0("W", 1:12, "F"))]

dataa = melt(datam, id = "ID", value.name = "Points")

#load the data for each team 

########################
# preparing data for JAGS 

ffdata.dat = list(id = as.integer(dataa$ID),
	points = dataa$Points,
	week = as.integer(dataa$variable),
	N = nrow(dataa),
	I = length(unique(dataa$ID)))

########################
# JAGS model; switching to the textConnection trick 

model_string = "
	# Fixing data to be used in model definition
	data{
  	zero[1] <- 0
  	zero[2] <- 0
  	R[1,1] <- 0.1
  	R[1,2] <- 0
  	R[2,1] <- 0
  	R[2,2] <- 0.5
	}
	# Then define model
	model {
	# Intercept and slope for each person, including random effects
	for( i in 1:I ){
  	u[i,1:2] ~ dmnorm(zero,Omega.u)
	}
	# Define model for each observational unit
	for( j in 1:N ){
  	mu[j] <- ( beta[1] + u[id[j],1] ) +
  	( beta[2] + u[id[j],2] ) * ( week[j])
  	points[j] ~ dnorm( mu[j], tau.e )
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
  
ffdata.mod <- jags.model( textConnection(model_string),
	data = ffdata.dat,
	n.chains = 4,
	n.adapt = 100)
  
ffdata.res <- coda.samples( ffdata.mod,
	var = c("beta","sigma.e", "Sigma.u", "u"),
	n.iter = 500,
	thin = 5 )
  
summary(ffdata.res)
plot(ffdata.res)