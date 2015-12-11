library(rjags)
library(reshape2)

setwd("/Users/amckenz/Documents/github/R-plots/BDA")

#load ff data 
data = read.csv("/Users/amckenz/Documents/github/FantasyFootball/FFStats.csv")
data$ID = 1:length(data$Owner)
datam = data[ , c("ID", paste0("W", 1:12, "F"))]
dataa = melt(datam, id = "ID", value.name = "Points")

# N.B.: This function expects the data to be a data frame, 
# with one component named y being a vector of integer 0,1 values,
# and one component named s being a factor of subject identifiers.

Ntotal = length(dataa$Points)
# Specify the data in a list, for later shipment to JAGS:
dataList = list(
  y = dataa$Points ,
  x = dataa$ID ,
  Ntotal = Ntotal ,
  meanY = mean(dataa$Points) ,
  sdY = sd(dataa$Points)
)


#script from DBDA 
modelString = "
model {
  for ( i in 1:Ntotal ) {
    y[i] ~ dt( mu[x[i]] , 1/sigma[x[i]]^2 , nu )
  }
  for ( j in 1:10 ) { # 10 groups
    mu[j] ~ dnorm( meanY , 1/(100*sdY)^2 )
    sigma[j] ~ dunif( sdY/1000 , sdY*1000 )
  }
  nu ~ dexp(1/30.0)
}"

ffdata.mod = jags.model( textConnection(modelString),
	data = dataList,
	n.chains = 4,
	n.adapt = 100)
  
parameters = c( "mu" , "sigma" , "nu" )     # The parameters to be monitored
adaptSteps = 500               # Number of steps to "tune" the samplers
burnInSteps = 1000
runJagsOut <- run.jags( model="TEMPmodel.txt" , 
                        monitor=parameters , 
                        data=dataList ,  
                        n.chains=4 ,
                        adapt=100 ,
                        summarise=FALSE ,
                        plots=FALSE )
codaSamples = as.mcmc.list( runJagsOut )

summary(runJagsOut)
