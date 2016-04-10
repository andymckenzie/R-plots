setwd("/Users/amckenz/Desktop")
features = read.delim("invariant.features_t_cc.tsv")

features$fisher_zt = 0.5 * log((1 + features$cc.filt)/(1 - features$cc.filt))

res = lm(features$fisher_zt ~ features$age + as.factor(features$gender) +
  as.numeric(features$bmi) + as.factor(features$is_emergency) +
  as.numeric(features$asa_status) + as.factor(features$RACE))

coef_df_simple_lm = coef(summary(res))
