#data from 538's survey 
star_wars_survey = read.table("/Users/amckenz/Dropbox/random_research/StarWars.csv", sep = ",")


#fan = V3
#seen = V2
#income = V36
#age = V35
#sex = V34

star_wars_survey$V36[star_wars_survey$V36 == ""] = NA
star_wars_survey$V3[star_wars_survey$V3 == ""] = NA
star_wars_survey$V34[star_wars_survey$V34 == ""] = NA
star_wars_survey$V2[star_wars_survey$V2 == ""] = NA


star_wars_survey$V36 = as.factor(star_wars_survey$V36) 
levels(star_wars_survey$V36) = c("$0 - $24,999", "$25,000 - $49,999", 
       "$50,000 - $99,999", "$100,000 - $149,999", "$150,000+")

cor(as.numeric(star_wars_survey$V36), as.numeric(as.factor(star_wars_survey$V3)), method = "spearman", use = "na.or.complete")
#income is not correlated with being a star wars fan 
#0.007949709

cor(as.numeric(as.factor(star_wars_survey$V34)), as.numeric(as.factor(star_wars_survey$V3)), method = "spearman", use = "na.or.complete")
#being male IS correlated with being a star wars fan... p = 0.01, rho = 0.13

cor(as.numeric(as.factor(star_wars_survey$V34)), as.numeric(as.factor(star_wars_survey$V2)), method = "spearman", use = "na.or.complete")
#being male is correlated with having seen star wars, p = 0.0006, rho = 0.15

#stratify on only people who have seen star wars... 
star_wars_seen = star_wars_survey[as.factor(star_wars_survey$V2) == "Yes", ]

cor(as.numeric(as.factor(star_wars_seen$V34)), as.numeric(as.factor(star_wars_seen$V3)), method = "spearman", use = "na.or.complete")




