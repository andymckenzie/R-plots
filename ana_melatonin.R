library(readxl)
library(ggplot2)

mgsub <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}

melatonin = read.delim("Melatonin_dose_response.tsv")
melatonin$pill = melatonin$What.was.the.number.of.the.pill.you.took.
melatonin$pill[grep("16", melatonin$pill)] = 16
melatonin$pill = as.numeric(melatonin$pill)
melatonin$sleep_hours = melatonin$How.much.did.you.sleep.last.night......in.hours.
melatonin$estimated_prob = melatonin$What.s.your.estimated.probability.that.it.was.placebo...0.1.scale..obviously.prior.is.0.2.
melatonin$sleep_quality = melatonin$What.was.the.quality.of.your.sleep.last.night.
melatonin$time_to_sleep = melatonin$How.long.did.it.take.you.to.get.to.sleep.last.night......in.hours.
melatonin$help_start_sleep = melatonin$How.helpful.was.the.pill.in.getting.you.to.sleep.
melatonin$help_staying_sleep = melatonin$How.helpful.was.the.pill.in.helping.you.stay.asleep.

#for each category... merge the pill number with the category, to get the category for each
cats = read_excel("melatonin_categories.xlsx")
categories = sapply(strsplit(cats$Key[1:5], "="), "[[", 2)

mela_merge = merge(melatonin, cats, by.x = "pill", by.y = "Bag #")
mela_merge$pill_type = mela_merge$Contents
for(i in 1:length(categories)){
  mela_merge$pill_type = gsub(paste0("^", i, "$"), categories[i], mela_merge$pill_type, perl = TRUE)
}

hours = ggplot(mela_merge, aes(x = pill_type, y = sleep_hours)) + theme_bw() +
  geom_boxplot()
prob = ggplot(mela_merge, aes(x = pill_type, y = estimated_prob)) + theme_bw() +
  geom_boxplot()
quality = ggplot(mela_merge, aes(x = pill_type, y = sleep_quality)) + theme_bw() +
  geom_boxplot()
time_to_sleep = ggplot(mela_merge, aes(x = pill_type, y = time_to_sleep)) + theme_bw() +
  geom_boxplot()
get_to_sleep = ggplot(mela_merge, aes(x = pill_type, y = help_start_sleep)) + theme_bw() +
  geom_boxplot()
stay_asleep = ggplot(mela_merge, aes(x = pill_type, y = help_staying_sleep)) + theme_bw() +
  geom_boxplot()


if(F){

  library(rstan)

  mcmc_data = list(
    N = nrow(mela_merge),
    nGroup = length(names(table(mela_merge$Contents))),
    sleep_data = mela_merge$How.much.did.you.sleep.last.night......in.hours.,
    pill_type = mela_merge$Contents)

  mcmc = stan("learn_stan/ana_melatonin.stan", data = mcmc_data, pars = c("mu", "sigma", "prior_mu", "prior_sigma"), iter = 200, chains = 1)

}
