#testing an autoregressive model of fantasy football trends
#following from http://doingbayesiandataanalysis.blogspot.com/2012/10/bayesian-estimation-of-trend-with-auto.html
#however, switching out the sinusoidal component so it's only linear

library(rjags)
library(reshape2)

#need to run in the BDA folder
data = read.csv("FFstats.csv")

data$ID = 1:length(data$Owner)

datam = data[ , c("ID", paste0("W", 1:12, "F"))]

dataa = melt(datam, id = "ID", value.name = "Points")

#load the data for each team

########################
# preparing data for JAGS
#also make a team variable so that we can estimate this for each group
ffdata_dat = list(
  id = as.integer(dataa$ID),
	y = dataa$Points,
	x = as.integer(dataa$variable), #week
	Nteams = length(unique(dataa$ID)),
  Ndata = nrow(dataa))

model_string = " model {
    for( teamIndx in 1 : Nteams){
      beta0[teamIndx] ~ dnorm( 0 , 1.0E-12 )
      beta1[teamIndx] ~ dnorm( 0 , 1.0E-12 )
      ar1[teamIndx] ~ dunif(-1.1,1.1)
    }
    trend[1] <- beta0[id[1]] + beta1[id[1]] * x[1]
    for( i in 2 : Ndata ) { #where i = data point
      y[i] ~ dt( mu[i] , tau , nu )
      mu[i] <- trend[i] + ar1[id[i]] * ( y[i-1] - trend[i-1] )
      trend[i] <- beta0[id[i]] + beta1[id[i]] * x[i]
    }
    tau ~ dgamma( 0.001 , 0.001 )
    thresh ~ dunif(-183,183)
    nu <- nuMinusOne + 1
    nuMinusOne ~ dexp(1/29)
}"

# if(F){

ffdata_mod <- jags.model( textConnection(model_string),
	data = ffdata_dat,
	n.chains = 4,
	n.adapt = 100)

update(ffdata_mod, 500) # burn-in

if(F){

ffdata_res <- coda.samples( ffdata_mod,
	var = c("ar1", "beta0", "beta1", "tau", "nu"),
	n.iter = 500,
	thin = 5 )

summary(ffdata_res)
plot(ffdata_res)

}

# }
