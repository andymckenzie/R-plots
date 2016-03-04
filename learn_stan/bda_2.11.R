#Suppose y1, ..., y5 are independent samples from a Cauchy distribution with
#unknown center theta and known scale 1. Assume that the prior distribution for theta
#is uniform on [0,100]. Find the posterior density.

library(rstan)

observations = c(43, 44, 45, 46.5, 47.5)

nuts_data = list(
  observations = observations,
  N = length(observations))

nuts = stan(file = "bda_2.11.stan", data = nuts_data, pars = "theta")

# stan.test <- stan(file = "cell_6.12.stan", data = cell_type_data,
#   pars=c('ct_props'), chains = 1, iter = 100, warmup = 50)
