#Assume these surveys are independent simple random samples from the population of registered voters.
#Model the data with two different multinomial distributions.
#For j = 1, 2, let a_j be the proportion of voters who preferred Bush,
#out of those who had a preference for either Bush or Dukakis at the time of survey j
#Plot a histogram of the posterior density for a_2 - a_1.
#What is the posterior probability that there was a shift towards Bush?

library(rstan)

pre_debate = c(294, 307)
post_debate = c(288, 332)

nuts_data = list(
  K = 2,
  N = length(pre_debate),
  pre_debate = pre_debate,
  post_debate = post_debate)

nuts = stan(file = "bda_3.2.stan", data = nuts_data, pars = c("alpha1", "alpha2"))
