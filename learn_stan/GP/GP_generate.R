
library(rstan)

setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/GP")

x = rnorm(1000, 50, 5)
y = rcauchy(1000, 50, 5)

mcmc_data = list(
  N = length(x),
  x = x,
  y = y)

mcmc = stan("GP_generate.stan", data = mcmc_data, pars = c("y"), iter = 200, chains = 1)
