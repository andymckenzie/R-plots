#building a model for ex 5.15; a meta analysis of clinical trial data

library(rstan)

clin = read.table("bda_table_5_2_clin_trials.txt", header = TRUE)

#calculate log odds
clin$log_odds = log(clin$treated.deaths/(clin$treated.total - clin$treated.deaths)) -
  log(clin$control.deaths/(clin$control.total - clin$control.deaths))
clin$odds_sd = 1/clin$treated.deaths + 1/(clin$treated.total - clin$treated.deaths) +
  1/clin$control.deaths + 1/(clin$control.total - clin$control.deaths)

nuts_data = list(
  N = length(clin$log_odds),
  log_odds = clin$log_odds,
  odds_sd = clin$odds_sd)

nuts = stan(file = "bda_5_15.stan", data = nuts_data, pars = c("theta", "mu", "tau"))
