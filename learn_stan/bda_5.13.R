

library(rstan)

res_bike_bikes = c(16, 9, 10, 13, 19, 20, 18, 17, 35, 55)
res_bike_other = c(58, 90, 48, 57, 103, 57, 86, 112, 273, 64)

nuts_data = list(
  N = length(res_bike_bikes),
  res_bike_bikes = res_bike_bikes,
  res_bike_other = res_bike_other)

nuts = stan(file = "bda_5.13.stan", data = nuts_data, pars = c("theta", "theta_hyper_alpha", "theta_hyper_beta"))
