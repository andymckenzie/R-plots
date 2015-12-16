#testing an autoregressive model of fantasy football trends
#following from http://doingbayesiandataanalysis.blogspot.com/2012/10/bayesian-estimation-of-trend-with-auto.html
#however, switching out the sinusoidal component so it's only linear

library(rjags)
library(reshape2)

ESPN = TRUE
fleaflicker = FALSE

#need to run in the BDA folder
if(ESPN){
  data = read.csv("ffdata_week14.csv")
  data$ID = 1:length(data$Owner)
  datam = data[ , c("ID", paste0("W", 1:14, "F"))]
  dataa = melt(datam, id = "ID", value.name = "Points")
}

if(fleaflicker){
  data = read.csv("/Users/amckenz/Documents/github/FantasyFootball/FFStats.csv")
  data$ID = 1:length(data$Owner)
  datam = data[ , c("ID", paste0("W", 1:12, "F"))]
  dataa = melt(datam, id = "ID", value.name = "Points")
}

#load the data for each team

#to predict next week
IDs = c(as.integer(dataa$ID), 1:length(unique(dataa$ID)))
y = c(dataa$Points, rep(NA, length(unique(dataa$ID))))
x = c(as.integer(dataa$variable), rep(max(as.integer(dataa$variable)),
  length(unique(dataa$ID))))

########################
# preparing data for JAGS
#also make a team variable so that we can estimate this for each group
ffdata_dat = list(
  id = IDs,
	y = y,
	x = x, #week
	Nteams = length(unique(IDs)),
  Ndata = length(y))

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

ffdata_res <- coda.samples( ffdata_mod,
	var = c("ar1", "beta0", "beta1", "tau", "nu", "y"),
	n.iter = 2000,
	thin = 5 )

summary(ffdata_res)
# plot(ffdata_res)

emmett_mcmc <- unlist(ffdata_res[ , "y[141]"])
mike_mcmc <- unlist(ffdata_res[ , "y[147]"])
eddy_mcmc <- unlist(ffdata_res[ , "y[143]"])
jnay_mcmc <- unlist(ffdata_res[ , "y[149]"])

sum(emmett_mcmc - mike_mcmc > 0)/length(eddy_mcmc)
mean(emmett_mcmc - mike_mcmc)

sum(eddy_mcmc - jnay_mcmc > 0)/length(eddy_mcmc)
mean(eddy_mcmc - jnay_mcmc)

ranjan_mcmc <- unlist(ffdata_res[ , "y[141]"])
max_mcmc <- unlist(ffdata_res[ , "y[147]"])
eddy_mcmc <- unlist(ffdata_res[ , "y[143]"])
jnay_mcmc <- unlist(ffdata_res[ , "y[149]"])

sum(ranjan_mcmc - max_mcmc > 0)/length(eddy_mcmc)
mean(ranjan_mcmc - max_mcmc)

sum(eddy_mcmc - jnay_mcmc > 0)/length(eddy_mcmc)
mean(eddy_mcmc - jnay_mcmc)

predict_matchup <- function(var1, var2){

  team1 = unlist(ffdata_res[ , var1])
  team2 = unlist(ffdata_res[ , var2])

  prob_team1 = sum(team1 - team2 > 0)/length(team1)
  mean_diff_team1 = sum(team1 - team2 > 0)/length(team1)

  print(prob_team1)

}




# }
