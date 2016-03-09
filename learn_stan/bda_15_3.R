library(rstan)

setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/")

chem = read.table("table_15_2.txt", header = TRUE)

mcmc_data = list(
  N = nrow(chem),
  temp = chem$temperature,
  temp_sq = chem$temperature^2,
  ratio = chem$ratio,
  ratio_sq = chem$ratio^2,
  contact = chem$contact,
  contact_sq = chem$contact^2,
  temp_ratio = chem$temperature*chem$ratio,
  temp_contact = chem$temperature*chem$contact,
  ratio_contact = chem$ratio*chem$contact,
  conversion = chem$conversion)

mcmc = stan(file = "bda_15_3.stan", data = mcmc_data, pars = c("beta", "constant", "beta_mean", "sigma"), iter = 1000, chains = 1, control = list(max_treedepth = 20, stepsize = 5))
