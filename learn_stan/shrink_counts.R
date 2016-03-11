#following based on http://stats.stackexchange.com/questions/96481/how-to-specify-a-bayesian-binomial-model-with-shrinkage-to-the-population
#also based on http://lingpipe-blog.com/2009/09/23/bayesian-estimators-for-the-beta-binomial-model-of-batting-ability/

library(rstan)
library(ggplot2)

baseball = read.table("baseball_data.txt", header = TRUE)

mcmc_data = list(
  N = nrow(baseball),
  hits = baseball$hits,
  atbats = baseball$atbats)

mcmc = stan("shrink_counts.stan", data = mcmc_data, pars = c("probs", "prior_average", "prior_atbats"), iter = 200, chains = 1)

res = summary(mcmc)$summary
res = res[grepl("probs", rownames(res)), ]
prob_hats = res[, "mean"]

raw_probs = baseball$hits/baseball$atbats

shrink = data.frame(prob_hats, raw_probs, atbats = baseball$atbats)

shrink_plot = ggplot(data = shrink, aes(x = raw_probs, y = prob_hats)) +
  geom_point(aes(color = log(atbats))) + theme_bw() + ylab("Estimated Average") + xlab("Actual Average")
