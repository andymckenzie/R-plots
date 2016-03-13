
setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/") 

library(rstan)

sleep_data = rnorm(48, 7.25, 1)
pill_type = round(runif(48, 0.5, 5.5))

mcmc_data = list(
  N = length(sleep_data),
  nGroup = length(names(table(pill_type))),
  sleep_data = sleep_data,
  pill_type = pill_type)

mcmc = stan("ana_melatonin.stan", data = mcmc_data, pars = c("mu", "sigma", "prior_mu", "prior_sigma"), iter = 200, chains = 1)
