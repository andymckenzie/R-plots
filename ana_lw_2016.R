library(ggplot2)

surv = read.csv("/Users/amckenz/Downloads/2016_lw_survey_public_release_3.csv")

overall = table(surv$Cryonics)
overall_norm = table(surv$Cryonics)/sum(table(surv$Cryonics))
overall_df = data.frame(cats = names(overall), nums = overall, props = overall)
overall_df = overall_df[!overall_df$props.Var1 == "", ]
overall_df$props.Freq = overall_df$props.Freq/sum(overall_df$props.Freq)
overall_p = ggplot(overall_df, aes(x = cats, y = props.Freq)) +
  geom_bar(stat = "identity") + theme_bw() +
  theme(text = element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1)) +
  ylab("Proportion of Responses") + xlab("") +
  geom_text(aes(label = nums.Freq), position = position_dodge(width = 0.9), vjust = -0.25)

#SQ	0	8	1	What is the  probability that an average person cryonically frozen today will be  successfully restored to life at some future time, conditional on no  global catastrophe destroying civilization before then?		en
cryo_prob = surv$ProbabilityQuestions.8.

se <- function(x) { sd(x)/sqrt(length(x)) }

aggregate(ProbabilityQuestions.8. ~ Cryonics, data = surv, mean)
aggregate(ProbabilityQuestions.8. ~ Cryonics, data = surv, sd)

aggregate(ProbabilityQuestions.8. ~ CryonicsNow, data = surv, mean)

aggregate(ProbabilityQuestions.8. ~ CryonicsPossibility, data = surv, mean)

aggregate(ProbabilityQuestions.8. ~ Profession, data = surv, mean)

surv$Age[which.max(surv$Age)] = NA
surv$Age[which.max(surv$Age)] = NA
surv$age_cut = cut_number(surv$Age, n = 4)

aggregate(ProbabilityQuestions.8. ~ cut_number(surv$Age, n = 10), data = surv, mean)

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

aggregate(Cryonics_Sign_Num ~ cut_number(surv$Age, n = 10), data = surv, mean)
aggregate(ProbabilityQuestions.8. ~ CFARAttendance, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ CFARAttendance, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ cut_number(surv$Income, n = 10), data = surv, mean)
aggregate(ProbabilityQuestions.8. ~ cut_number(surv$Income, n = 5), data = surv, mean)
aggregate(Cryonics_Sign_Num ~ cut_number(surv$IQ, n = 5), data = surv, mean)
aggregate(Cryonics_Sign_Num ~ AmericanParties, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ cut_number(surv$Age, n = 5), data = surv, mean)
aggregate(Cryonics_Sign_Num ~ Country, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ EAIdentity, data = surv, mean)
aggregate(ProbabilityQuestions.8. ~ EAIdentity, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ ReligiousViews, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ PoliticsShort, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ OCD, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ AnxietyDisorder, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ ASD, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ Depression, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ SexualOrientation, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ ReligionType, data = surv, mean)

aggregate(Cryonics_Sign_Num ~ Feminism.SQ001., data = surv, mean)
aggregate(Cryonics_Sign_Num ~ NumberPartners, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ ADHD, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ WorkStatus.1., data = surv, mean)
aggregate(Cryonics_Sign_Num ~ FamilyReligion, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ ReligionType, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ EducationCredentials, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ AbortionLaws.SQ001., data = surv, mean)
aggregate(Cryonics_Sign_Num ~ cut_number(surv$SingularityYear, n = 5), data = surv, mean)
aggregate(Cryonics_Sign_Num ~ BasicIncome.SQ001., data = surv, mean)
aggregate(Cryonics_Sign_Num ~ RelationshipStyle, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ Vegetarian, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ MoreChildren, data = surv, mean)
aggregate(Cryonics_Sign_Num ~ Immigration.SQ001., data = surv, mean)
