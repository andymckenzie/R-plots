#want to do shrinkage estimation on scott's nootropics survey based on the sample size
#actually, possibly JK -- data cleaning may be too annoying... though the raw xls looks more promising in terms of importing

library(rstan)
library(readxl)

noot = read.table("scott_nootropic_2016_fixed.csv", sep = ",", header = FALSE, fill = TRUE, comment.char = "", quote = "")
nootxls = read_excel("scott_nootropic_2016_rawdata.xlsx")

#calculate log odds
clin$log_odds = log(clin$treated.deaths/(clin$treated.total - clin$treated.deaths)) -
  log(clin$control.deaths/(clin$control.total - clin$control.deaths))
clin$odds_sd = 1/clin$treated.deaths + 1/(clin$treated.total - clin$treated.deaths) +
  1/clin$control.deaths + 1/(clin$control.total - clin$control.deaths)

mcmc_data = list(
  N = length(clin$log_odds),
  log_odds = clin$log_odds,
  odds_sd = clin$odds_sd)

mcmc = stan(file = "bda_5_15.stan", data = nuts_data, pars = c("theta", "mu", "tau"))
