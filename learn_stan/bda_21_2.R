#Set up a Gaussian process model to estimate the percentage of people in the population
#who believe they know someone gay (in 2004), as a function of age.
#For simplicity you should use the normal approximation to the binomial distributiun
#for the proportion of Yes responses for each age.

library(rstan)

setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/")

naes = read.table("naes04.csv", sep = ",", header = TRUE)
naes_know = naes[!is.na(naes$gayKnowSomeone), ]
naes_know$know = ifelse(naes_know$gayKnowSomeone == "Yes", 1, 0)
age_know = aggregate(know ~ age, naes_know, mean)

test_GP = list(
  N = nrow(age_know),
  age = age_know$age,
  know = age_know$know)

mcmc = stan("bda_21_2.stan", data = test_GP, pars = c("y"), iter = 200, chains = 1)

res = summary(mcmc)$summary
res = res[!rownames(res) %in% c("lp__", "beta1"), ]

#yeah, this is definitely not working
plot(res[, "mean"], birth$births)
