library(ggplot2)
library(dplyr)

results_file = "/Users/amckenz/Documents/bpf_survey/Batch_1971592_batch_results.csv"

res = read.table(file = results_file, sep = ",", header = T, fill = T)

data_columns_start = 24
data_columns_end = 48
res_only = res[ , c(data_columns_start:data_columns_end)]

#analyses to do: 
#summary statistics of the BP questions
#statistcs of the BP questions segregated by demo variables
#correlations among all of the variables 
#linear models to predict BP responses based on the demo variables 

############################################################
#####            demographic data                      #####
############################################################

percent_female = sum(res$Answer.Gender == "Female")/
	length(res$Answer.Gender)
	
barplot(prop.table(table(res$Answer.Education[res$Answer.Education != ""])), 
	ylim = c(0,0.4)) 
	
health_factor = factor(res$Answer.Health[res$Answer.Health != ""], 
		c("Poor", "Fair", "Good", "VeryGood", "Excellent"))
	
barplot(prop.table(table(health_factor)), ylim = c(0,0.4)) 
	
barplot(prop.table(table(res$Answer.Health[res$Answer.Health != ""])), 
	ylim = c(0,0.4)) 

barplot(prop.table(table(res$Answer.Living[res$Answer.Living != ""])), 
	ylim = c(0,0.6)) 

barplot(prop.table(table(res$Answer.WhereHeard[res$Answer.WhereHeard != ""])), 
	ylim = c(0,0.7)) 

barplot(prop.table(table(res$Answer.ReligionGeneral[res$Answer.ReligionGeneral != ""])), 
	ylim = c(0,0.4)) 

barplot(prop.table(table(res$Answer.ReligionSpecific[res$Answer.ReligionSpecific != ""])), 
	ylim = c(0,0.6)) 
	
afterlife_factor = factor(res$Answer.Afterlife[res$Answer.Afterlife != ""], 
		c("Yes", "LikelyYes", "Unsure", "No", "LikelyNo"))

barplot(prop.table(table(afterlife_factor)), 
	ylim = c(0,0.4)) 
	
barplot(prop.table(table(res$Answer.Money[res$Answer.Money != ""])), 
	ylim = c(0,0.4)) 


hist(res$Answer.Age, freq = F, ylab = "Proportion", xlab = "Age")

############################################################
#####          converting likert to factor             #####    
############################################################

SignUp_N = as.numeric(factor(res_only$Answer.SignUp, 
	levels = c("No", "Unsure", "NoThinking", "NoPlanning", "Yes")))
Imagine_N = as.numeric(factor(res_only$Answer.Imagine, 
	levels = c("No", "LikelyNo", "Unsure", "LikelyYes", "Yes")))
Health_N = as.numeric(factor(res_only$Answer.Health, 
	levels = c("Poor", "Fair", "Good", "VeryGood", "Excellent")))
FriendSigns_N = as.numeric(factor(res_only$Answer.FriendSigns, 
	levels = c("NoMoreLikely", "Unsure", "YesSlightly", "YesMuch")))
Education_N = as.numeric(factor(res_only$Answer.Education, 
	levels = c("HighSchool", "TwoYear", "Bachelor", "ProfDegree", "Other")))
Afterlife_N = as.numeric(factor(res_only$Answer.Afterlife, 
	levels = c("No", "LikelyNo", "Unsure", "LikelyYes", "Yes")))
PreMortem_N = as.numeric(factor(res_only$Answer.PreMortem, 
	levels = c("StrongDisagree", "Disagree", "Unsure", "Agree", "StrongAgree")))  
Religiousness_N = as.numeric(factor(res_only$Answer.ReligionGeneral, 
	levels = c("AtheistNotSpiritual", "AtheistButSpiritual", 
	"Agnostic", "Other", "LukewarmTheist", "CommittedTheist"))) 

############################################################
#####            summary stats                         #####
############################################################

summary_stats_fxn <- function(survey_df){

	#proportion of people who have heard of it 
	heard_of_p = sum(survey_df$Answer.HeardOf == "Yes") / length(survey_df$Answer.HeardOf)
	heard_of_plot = plot(as.factor(survey_df$Answer.HeardOf))

	#proportion of people who could image doing it 
	imagine_p = sum(survey_df$Answer.Imagine %in% c("LikelyYes", "Yes")) / length(survey_df$Answer.Imagine)
	imagine_plot = plot(as.factor(survey_df$Answer.Imagine))

	#proportion of people thinking about electing to sign up, planning on it, or have already
	thinking_p = sum(survey_df$Answer.SignUp %in% c("NoThinking", "NoPlanning", "Yes")) / length(survey_df$Answer.SignUp)
	thinking_plot = plot(as.factor(survey_df$Answer.SignUp))

	#proportion of people who agree or stronglyagree that people should be allowed to do it prior to legal death
	premortem_p = sum(survey_df$Answer.PreMortem %in% c("Agree", "StrongAgree")) / length(survey_df$Answer.PreMortem)
	legaldeath_plot = plot(as.factor(survey_df$Answer.PreMortem))
	
	#average probability estimates 
	prob_BP = as.numeric(gsub("%", "", survey_df$Answer.ProbBP))	
	average_prob_BP = mean(prob_BP)
	prob_BP_plot = hist(prob_BP)	
	
	average_probs = c(heard_of_p, imagine_p, thinking_p, premortem_p, average_prob_BP)
	names(average_probs) = c("Heard Of", "Could Imagine", "Thinking About or Above", 
		"Pre-Legal Death Opinion", "Probability Assignment")
	
	return(list(average_probs, heard_of_plot, imagine_plot, thinking_plot, legaldeath_plot, prob_BP_plot))

}

total = summary_stats_fxn(res_only)

#each of the above broken down by *each of* age, health status, gender, and money made
greater40_total = summary_stats_fxn(res_only[res_only$Answer.Age > 40, ])
under40and40_total = summary_stats_fxn(res_only[res_only$Answer.Age <= 40, ])
female_total = summary_stats_fxn(res_only[which(res_only$Answer.Gender %in% c("FemaleTMF", "Female")), ])
male_total = summary_stats_fxn(res_only[which(res_only$Answer.Gender %in% c("MaleTFM", "Male")), ])
poor_or_fair_health_total = summary_stats_fxn(res_only[which(res_only$Answer.Health %in% c("Poor", "Fair")), ])
good_or_better_health_total = summary_stats_fxn(res_only[which(res_only$Answer.Health %in% c("Excellent", "Good", "VeryGood")), ])
money_50000_above_total = summary_stats_fxn(res_only[which(res_only$Answer.Money %in% c("50000to75000", "75000to100000", "100000plus")), ])
money_50000_below_total = summary_stats_fxn(res_only[which(res_only$Answer.Money %in% c("Less12500", "12500to25000", "25000to50000")), ])

############################################################
#########         BP Favorability Corrs                #####
############################################################

#should all be positively but not perfectly correlated to make this more valuable
cor(Imagine_N, PreMortem_N)
cor(SignUp_N, Imagine_N)

prob_BP = as.numeric(gsub("%", "", res_only$Answer.ProbBP))	

#see whether correlated with the probability of BP? 
plot(Imagine_N, prob_BP) 
plot(PreMortem_N, prob_BP) 
plot(SignUp_N, prob_BP) 

sum_BP_favorability = SignUp_N + Imagine_N + PreMortem_N

############################################################
#####            linear models                         #####
############################################################

prob_BP_lm = lm(prob_BP ~ Imagine_N + Health_N + FriendSigns_N +
	Education_N + Afterlife_N)

favor_lm = lm(sum_BP_favorability ~ Education_N + res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Age + res_only$Answer.Money + 
	Religiousness_N + res_only$Answer.Employment + res_only$Answer.HeardOf + 
	res_only$Answer.Living + res_only$Answer.MainReasonNoBP + 
	res_only$Answer.ReligionSpecific + res_only$Answer.WhereHeard) 
