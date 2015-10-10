#data from 538's survey 
star_wars_survey = read.table("/Users/amckenz/Dropbox/random_research/StarWars.csv", sep = ",")

RespondentID,Have you seen any of the 6 films in the Star Wars franchise?,Do you consider yourself to be a fan of the Star Wars film franchise?,Which of the following Star Wars films have you seen? Please select all that apply.,,,,,,Please rank the Star Wars films in order of preference with 1 being your favorite film in the franchise and 6 being your least favorite film.,,,,,,"Please state whether you view the following characters favorably, unfavorably, or are unfamiliar with him/her.",,,,,,,,,,,,,,Which character shot first?,Are you familiar with the Expanded Universe?,Do you consider yourself to be a fan of the Expanded Universe?Œæ,Do you consider yourself to be a fan of the Star Trek franchise?,Gender,Age,Household Income,Education,Location (Census Region)
,Response,Response,Star Wars: Episode I  The Phantom Menace,Star Wars: Episode II  Attack of the Clones,Star Wars: Episode III  Revenge of the Sith,Star Wars: Episode IV  A New Hope,Star Wars: Episode V The Empire Strikes Back,Star Wars: Episode VI Return of the Jedi,Star Wars: Episode I  The Phantom Menace,Star Wars: Episode II  Attack of the Clones,Star Wars: Episode III  Revenge of the Sith,Star Wars: Episode IV  A New Hope,Star Wars: Episode V The Empire Strikes Back,Star Wars: Episode VI Return of the Jedi,Han Solo,Luke Skywalker,Princess Leia Organa,Anakin Skywalker,Obi Wan Kenobi,Emperor Palpatine,Darth Vader,Lando Calrissian,Boba Fett,C-3P0,R2 D2,Jar Jar Binks,Padme Amidala,Yoda,Response,Response,Response,Response,Response,Response,Response,Response,Response

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




