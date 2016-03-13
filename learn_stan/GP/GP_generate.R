
library(rstan)

setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/GP")

x = rnorm(100, 5, 1)
y = rcauchy(100, 50, 5)

mcmc_data = list(
  N = length(x),
  x = x,
  y = y)

# mcmc = stan("GP_generate.stan", data = mcmc_data, pars = c("y", "z"), iter = 200, chains = 1)

# mcmc = stan("GP_example_fit.stan", data = mcmc_data, pars = c("eta_sq", "inv_rho_sq", "sigma_sq"), iter = 200, chains = 1)

x2 = rnorm(100, 3, 1)

mcmc_data_predict = list(
  N1 = length(x),
  x1 = x,
  y1 = y,
  N2 = length(x2),
  x2 = x2)

mcmc = stan("GP_ex_manual_predict.stan", data = mcmc_data_predict, pars = c("y2"), iter = 200, chains = 1)
