#Set up a Gaussian process model to estimate the percentage of people in the population
#who believe they know someone gay (in 2004), as a function of age.
#For simplicity you should use the normal approximation to the binomial distributiun
#for the proportion of Yes responses for each age.

library(rstan)

naes = read.table("naes04.csv", sep = ",", header = TRUE)

test_GP = list(
  N = 10,
  x = runif(10, 0, 1))

mcmc = stan("GP_ex_manual_15_2.stan", data = test_GP, pars = c("predict", "beta1"), iter = 400, chains = 1)

res = summary(mcmc)$summary
res = res[!rownames(res) %in% c("lp__", "beta1"), ]

#yeah, this is definitely not working 
plot(res[, "mean"], birth$births)
