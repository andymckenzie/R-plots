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
age_predict = 10:100

test_GP = list(
  N1 = nrow(age_know),
  x1 = age_know$age,
  z1 = age_know$know,
  N2 = length(age_predict),
  x2 = age_predict)

mcmc = stan("GP/bda_21_2.stan", data = test_GP, pars = c("y1", "y2"), iter = 200, chains = 2)

res = summary(mcmc)$summary
y1_mean = res[grep("y1", rownames(res)), "mean"]

plot(age_know$age, age_know$know)
lines(x = age_know$age, y = y1_mean),col=3)

y2_mean = res[grep("y2", rownames(res)), "mean"]
