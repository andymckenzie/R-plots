

library(rstan)

nuts_data = list(
  died1 = 39,
  total1 = 674,
  died2 = 22,
  total2 = 680)

nuts = stan(file = "bda_3.4.stan", data = nuts_data, pars = c("theta1", "theta2", "odds_ratio"))
