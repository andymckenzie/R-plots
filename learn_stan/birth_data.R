library(rstan)

set.seed(42)

births = rbinom(1e5, 1, 0.485)

mcmc = list(
  N = length(births),
  births = births)

mcmc = stan("birth_data.stan", data = mcmc, pars = c("prob"), iter = 200, chains = 1)

res = summary(mcmc)$summary
