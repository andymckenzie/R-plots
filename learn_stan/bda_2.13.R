#Assume that the numbers of fatal accidents in each year are independent
#with a Poisson(theta) distribution. Set a prior distribution for theta
#and determine the posterior distribution based on the data from 1976 to 1985
#Under this model, give a 95% predictive interval for the number of fatal accidents
#in 1986.

#Since they are independent, a 95% CI for theta is the same as a predictive interval for 1986, IIUC

library(rstan)

passenger_deaths = c(734, 516, 754, 877, 814, 362, 764, 809, 223, 1066)

nuts_data = list(
  N = length(passenger_deaths),
  deaths = passenger_deaths)

nuts = stan(file = "bda_2.13.stan", data = nuts_data, pars = c("theta",
  "mean_p", "scale"))
