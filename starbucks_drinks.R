#reads in comma separated value file with data of starbucks drinks
#filters drinks by calorie count, normalizes to calorie count by drink
#creates scatterplot of output via ggplot2
#analyzing data in R from http://www.factual.com/t/hrHQV1/Starbucks_Nutrition_Info_for_Grande_Size_with_2_Milk_loaded_Sep_2008

library(ggplot2)

a = read.table("Starbucks_Nutrition_Info_for_Grande_Size_with_2%_Milk_(loaded_Sep_2008).csv", sep=",", head=T, encoding = "unknown")

#filters by calorie totals; otherwise, the results can be biased by quotients of small numbers
b = subset(a, Calories>50)

#normalizes to nutrition info
Sodium = b$Sodium / b$Calories
Sugar = b$Sugar / b$Calories

#creates plot
qplot(Sodium,Sugar)+geom_smooth()