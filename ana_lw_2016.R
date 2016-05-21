library(ggplot2)

surv = read.csv("/Users/amckenz/Downloads/2016_lw_survey_public_release_3.csv")

overall = table(surv$Cryonics)
overall_norm = table(surv$Cryonics)/sum(table(surv$Cryonics))
overall_df = data.frame(cats = names(overall), nums = overall, props = overall)
overall_df = overall_df[!overall_df$props.Var1 == "", ]
overall_df$props.Freq = overall_df$props.Freq/sum(overall_df$props.Freq)
overall_df[overall_df$cats == "Never thought about it / don't understand", "cats"] = "Never thought about it"
overall_p = ggplot(overall_df, aes(x = cats, y = props.Freq)) +
  geom_bar(stat = "identity") + theme_bw() +
  theme(text = element_text(size=15), axis.text.x = element_text(angle = 60, hjust = 1)) +
  ylab("Proportion of Responses") + xlab("") +
  geom_text(aes(label = nums.Freq), position = position_dodge(width = 0.9), vjust = -0.25)
ggsave(overall_p, file = "overall_cryo_interest.jpeg", width = 8, height = 8)

#SQ	0	8	1	What is the  probability that an average person cryonically frozen today will be  successfully restored to life at some future time, conditional on no  global catastrophe destroying civilization before then?		en

se <- function(x) { sd(x)/sqrt(length(x)) }
plot_aggregate <- function(x, err, ylab, xlab = "", order = FALSE){
  colnames(x) = c("cat", "nums")
  colnames(err) = c("cat2", "ses")
  tmp = cbind(x, err)
  tmp$max = tmp$nums + tmp$ses
  tmp$min = tmp$nums - tmp$ses
  if(order){
    tmp$cat <- factor(tmp$cat, levels = unique(tmp$cat))
  }
  overall_p = ggplot(tmp, aes(x = cat, y = nums, ymax = max, ymin = min)) +
    geom_pointrange(stat = "identity") + theme_bw() +
    theme(text = element_text(size=17), axis.text.x = element_text(angle = 60, hjust = 1)) +
    ylab(ylab) + xlab(xlab)
  return(overall_p)
}

means = aggregate(ProbabilityQuestions.8. ~ Cryonics, data = surv, mean)
means[means$Cryonics == "Never thought about it / don't understand", "Cryonics"] = "Never thought about it"
ses = aggregate(ProbabilityQuestions.8. ~ Cryonics, data = surv, se)
means = means[!means$Cryonics == "",]
ses = ses[!ses$Cryonics == "",]
plot_save = plot_aggregate(means, ses, "Probability That Cryonics Works")
ggsave(plot_save, file = "prob_cryo_given_signup.jpeg", width = 8, height = 8)

# aggregate(ProbabilityQuestions.8. ~ CryonicsNow, data = surv, mean)
# aggregate(ProbabilityQuestions.8. ~ CryonicsPossibility, data = surv, mean)
# aggregate(ProbabilityQuestions.8. ~ Profession, data = surv, mean)

means = aggregate(ProbabilityQuestions.8. ~ cut_number(surv$Age, n = 6), data = surv, mean)
ses = aggregate(ProbabilityQuestions.8. ~ cut_number(surv$Age, n = 6), data = surv, se)
plot_save = plot_aggregate(means, ses, "Probability That Cryonics Works", "Age")
ggsave(plot_save, file = "prob_cryo_given_age.jpeg", width = 8, height = 8)

surv$Cryonics_Sign_Num = surv$Cryonics
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == ""] = NA
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "Never thought about it / don't understand"] = NA
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "No - and do not want to sign up for cryonics"] = 0
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "No - still considering it"] = 1
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "No - would like to sign up but can't afford it"] = 2
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "No - would like to sign up but haven't gotten around to it"] = 3
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "No - would like to sign up but unavailable in my area"] = 4
surv$Cryonics_Sign_Num[surv$Cryonics_Sign_Num == "Yes - signed up or just finishing up paperwork"] = 5
surv$Cryonics_Sign_Num = as.numeric(surv$Cryonics_Sign_Num)

means = aggregate(Cryonics_Sign_Num ~ cut_number(surv$Age, n = 6), data = surv, mean)
ses = aggregate(Cryonics_Sign_Num ~ cut_number(surv$Age, n = 6), data = surv, se)
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Age")
ggsave(plot_save, file = "interest_cryo_given_age.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ Gender, data = surv, mean)
means = means[!means$Gender == "", ]
ses = aggregate(Cryonics_Sign_Num ~ Gender, data = surv, se)
ses = ses[!ses$Gender == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Gender")
ggsave(plot_save, file = "interest_cryo_given_Gender.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ cut_number(surv$Income, n = 6), data = surv, mean)
ses = aggregate(Cryonics_Sign_Num ~ cut_number(surv$Income, n = 6), data = surv, se)
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Income (USD)")
ggsave(plot_save, file = "interest_cryo_given_income.jpeg", width = 8, height = 8)

means = aggregate(Cryonics_Sign_Num ~ Country, data = surv, mean)
means = means[!means$Country == "", ]
ses = aggregate(Cryonics_Sign_Num ~ Country, data = surv, se)
ses = ses[!ses$Country == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Country")
ggsave(plot_save, file = "interest_cryo_given_country.jpeg", width = 8, height = 8)

means = aggregate(Cryonics_Sign_Num ~ AmericanParties, data = surv, mean)
means = means[-c(1:2), ]
ses = aggregate(Cryonics_Sign_Num ~ AmericanParties, data = surv, se)
ses = ses[-c(1:2), ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Party (U.S.)")
ggsave(plot_save, file = "interest_cryo_given_us_party.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ PoliticsShort, data = surv, mean)
means = means[!means$PoliticsShort == "", ]
means[means$PoliticsShort == "Communist, for example the old Soviet Union: complete state control of many facets of life", "PoliticsShort"] = "Communist"
means[means$PoliticsShort == "Conservative, for example the US Republican Party and UK Tories: traditional values, low taxes, low redistribution of wealth", "PoliticsShort"] = "Conservative"
means[means$PoliticsShort == "Liberal, for example the US Democratic  Party or the UK Labour Party: socially permissive, more taxes, more redistribution of wealth", "PoliticsShort"] = "Liberal"
means[means$PoliticsShort == "Libertarian, for example like the US Libertarian Party: socially permissive, minimal/no taxes, minimal/no distribution of wealth", "PoliticsShort"] = "Libertarian"
means[means$PoliticsShort == "Social democratic, for example Scandinavian countries: socially permissive, high taxes, major redistribution of wealth", "PoliticsShort"] = "Social democratic"
ses = aggregate(Cryonics_Sign_Num ~ PoliticsShort, data = surv, se)
ses = ses[!ses$PoliticsShort == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Politics")
ggsave(plot_save, file = "interest_cryo_given_politics.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ EAIdentity, data = surv, mean)
ses = aggregate(Cryonics_Sign_Num ~ EAIdentity, data = surv, se)
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Effective Altruist Identification?")
ggsave(plot_save, file = "interest_cryo_given_EA.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ ReligiousViews, data = surv, mean)
means = means[!means$ReligiousViews == "", ]
ses = aggregate(Cryonics_Sign_Num ~ ReligiousViews, data = surv, se)
ses = ses[!ses$ReligiousViews == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Religious Views")
ggsave(plot_save, file = "interest_cryo_given_religion.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ ReligionType, data = surv, mean)
means[means$ReligionType == "Christian (Other non-Protestant, eg Eastern Orthodox)", "ReligionType"] = "Christian (Other non-Protestant)"
means = means[!means$ReligionType == "", ]
ses = aggregate(Cryonics_Sign_Num ~ ReligionType, data = surv, se)
ses = ses[!ses$ReligionType == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Religious Type")
ggsave(plot_save, file = "interest_cryo_given_religion_type.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ ASD, data = surv, mean)
means[means$ASD == "Not formally, but I personally believe I have (or had) it", "ASD"] = "Yes (By Personal Belief)"
means[means$ASD == "Yes, I was formally diagnosed by a doctor or other mental health professional", "ASD"] = "Yes (Formally Diagnosed)"
means = means[!means$ASD == "", ]
ses = aggregate(Cryonics_Sign_Num ~ ASD, data = surv, se)
ses = ses[!ses$ASD == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Autism Spectrum Disorder")
ggsave(plot_save, file = "interest_cryo_given_ASD.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ EducationCredentials, data = surv, mean)
means = means[-1, ]
ses = aggregate(Cryonics_Sign_Num ~ EducationCredentials, data = surv, se)
ses = ses[-1, ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Education Credentials")
ggsave(plot_save, file = "interest_cryo_given_education.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ Profession, data = surv, mean)
means = means[-1, ]
ses = aggregate(Cryonics_Sign_Num ~ Profession, data = surv, se)
ses = ses[-1, ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Profession")
ggsave(plot_save, file = "interest_cryo_given_Profession.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ AbortionLaws.SQ001., data = surv, mean)
means = means[-1, ]
means = means[match(c("Pro-Life", "Lean Pro-Life", "No strong opinion", "Lean Pro-Choice", "Pro-Choice"), means$AbortionLaws.SQ001.), ]
ses = aggregate(Cryonics_Sign_Num ~ AbortionLaws.SQ001., data = surv, se)
ses = ses[-1, ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Stance Towards Abortion", order = TRUE)
ggsave(plot_save, file = "interest_cryo_given_abortion.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ Vegetarian, data = surv, mean)
means = means[-1, ]
means[means$Vegetarian == "Yes, I restrict meat some other way (pescetarian, flexitarian, try to only eat ethically sourced meat)", "Vegetarian"] = "Restrict meat"
means = means[match(c("No", "Restrict meat", "Yes, I am vegetarian", "Yes, I am vegan"), means$Vegetarian), ]
ses = aggregate(Cryonics_Sign_Num ~ Vegetarian, data = surv, se)
ses = ses[-1, ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "", order = TRUE)
ggsave(plot_save, file = "interest_cryo_given_vegetarian.jpeg", width = 8, height = 6)

means = aggregate(Cryonics_Sign_Num ~ Race, data = surv, mean)
means = means[!means$Race == "", ]
ses = aggregate(Cryonics_Sign_Num ~ Race, data = surv, se)
ses = ses[!ses$Race == "", ]
plot_save = plot_aggregate(means, ses, "Interest in Cryonics", "Self-Reported Race/Ethnicity")
ggsave(plot_save, file = "interest_cryo_given_Race.jpeg", width = 8, height = 6)
