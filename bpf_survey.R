library(ggplot2)
library(dplyr)

results_file = "/Users/amckenz/Documents/bpf_survey/Batch_1950191_batch_results.csv"

res = read.table(file = results_file, sep = ",", header = T, fill = T)

data_columns_start = 24
data_columns_end = 48
res_only = res[ , c(data_columns_start:data_columns_end)]

############################################################
#####          converting likert to factor             #####    
############################################################


prob_BP = as.numeric(gsub("%", "", res_only$Answer.ProbBP))
SignUp_N = as.numeric(factor(res_only$Answer.SignUp, 
	levels = c("No", "Unsure", "NoThinking", "NoPlanning", "Yes")))
Imagine_N = as.numeric(factor(res_only$Answer.Imagine, 
	levels = c("No", "LikelyNo", "Unsure", "LikelyYes", "Yes")))
Health_N = as.numeric(factor(res_only$Answer.Health, 
	levels = c("Poor", "Fair", "Good", "VeryGood", "Excellent")))
FriendSigns_N = as.numeric(factor(res_only$Answer.FriendSigns), 
	levels = c("NoMoreLikely", "Unsure", "YesSlightly", "YesMuch"))))
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

demo_variables = c("Answer.Age", "Answer.Educaion", "WorkTimeInSeconds", 
	"Answer.Employment", "Answer.Gender", 
	"Answer.Health", "Answer.Living", "Answer.MainReasonNoBP", 
	"Answer.Money", "Answer.ReligionGeneral", 
	"Answer.ReligionSpecific", "Answer.WhereHeard")
BP_variables = c("Answer.Afterlife", "Answer.FriendSigns", 
""
PreMortem_Nums = as.numeric(factor(res_only$Answer.PreMortem, 
	levels = c("StrongDisagree", "Disagree", "Unsure", "Agree", "StrongAgree")))  

#analyses to do: 
#summary statistics of the BP questions
#statistcs of the BP questions segregated by demo variables
#linear models to predict responses based on the demo variables 
#correlations among all of the variables 

#build a linear model of the demographic variables to predict whether they could imagine electing to do it ... (or one of the other key response variables)

prob_BP = as.numeric(gsub("%", "", res_only$Answer.ProbBP))

a = lm(prob_BP ~ res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Health + res_only$Answer.Afterlife)

	
b = lm(Imagine_Nums ~ res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Health + res_only$Answer.Afterlife +  
	res_only$Answer.ReligionGeneral)
	
#res_only[ , which(names(res_only) %in% demo_variables)]
	
c = lm(PreMortem_Nums ~ res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Health + res_only$Answer.Afterlife +  
	res_only$Answer.ReligionGeneral + res_only$Answer.Age + res_only$Answer.Education + 
	res_only$Answer.Money) 

############################################################
#########         BP Favorability Corrs                #####
############################################################

#should all be positively but not perfectly correlated to make this more valuable
cor(Imagine_N, PreMortem_N)
cor(SignUp_N, Imagine_N)

#see whether correlated with the probability of BP? 
plot(Imagine_N, prob_BP) 
plot(PreMortem_N, prob_BP) 
plot(SignUp_N, prob_BP) 

sum_BP_favorability = SignUp_N + Imagine_N + PreMortem_N

############################################################
#####            linear models                         #####
############################################################


sum_BP_favorability

prob_BP_lm = lm(prob_BP ~ Imagine_N + Health_N + FriendSigns_N +
	Education_N + Afterlife_N)

favor_lm = lm(sum_BP_favorability ~ Education_N + res_only$Answer.Employment + 
	res_only$Answer.Gender + res_only$Answer.Age + res_only$Answer.Money + 
	Religiousness_N + res_only$Answer.Employment + res_only$Answer.HeardOf + 
	Afterlife_N + res_only$Answer.Living + res_only$Answer.MainReasonNoBP + 
	res_only$Answer.ReligionSpecific + res_only$Answer.WhereHeard) 



	#Health_N
