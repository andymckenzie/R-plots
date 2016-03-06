#Data: National Vital Statistics System data, provided by Google BigQuery exported to cvs by Chris Mulligan (sum data http://chmullig.com/wp-content/uploads/2012/06/births.csv)
#via Ati http://research.cs.aalto.fi/pml/software/gpstuff/demo_births.shtml
#also a bit off of https://github.com/pviefers/GaussianIcecream/blob/master/gp-BIN-fit_v05.stan

library(rstan)

birth = read.delim("births.csv", sep = ",")
#remove outlier miscoded data
birth = birth[!birth$births < 10000, ]
#multiply leap year times 4
birth[birth$month == 2 & birth$day == 29, "births"] = birth[birth$month == 2 & birth$day == 29, "births"] * 4
birth$doy = seq(1, nrow(birth), 1)

test_GP = list(
  N = nrow(birth),
  x = birth$doy,
  y = birth$births)

mcmc = stan("GP_ex_manual_15_2.stan", data = test_GP, pars = c("predict", "beta1"), iter = 200, chains = 1)
