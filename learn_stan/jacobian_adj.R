#want to come up with a simple example where Jacobian adjustments of the probability density are necessary
#running manual problem #16.3; slight inaccuracy in the manual but it's OK 

library(rstan)
set.seed(42)

data_gamma = rgamma(100, 4, 4)

nuts_data = list(
  x = data_gamma,
  N = length(data_gamma))

nuts = stan(file = "jacobian_adj.stan", data = nuts_data, pars = c("y", "y_inv"))
