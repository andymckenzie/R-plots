
library(readxl)
library(data.table) 

setwd("/Users/amckenz/Documents/nfl/")

qb = read_excel("NFL\ Stats\ 2008-2014.xlsx", sheet = 1)
qb$Name = gsub(" ", "", qb$Name)

qb2014 = qb[which(qb$Season == "2014"), ]

qb2014 = data.table(qb2014) 

qb2014rat = aggregate(qb2014$QBRat, by=list(qb2014$Name), FUN=mean)

#some surprises in the top 10 ... maybe would be best for a little bit of shrinkage estimation based on number of games ...  

 qb2014rato = qb2014rat[order(qb2014rat$x, decreasing = TRUE), ]

# > head(qb2014rato, 10)
#              Group.1        x
# 9      BrandonWeeden 114.7250
# 73          TonyRomo 113.5200
# 1       AaronRodgers 113.2313
# 23     DerekAnderson 113.0000
# 58     PeytonManning 104.0125
# 6  BenRoethlisberger 102.6063
# 7      BlaineGabbert 100.0000
# 25         DrewBrees  98.5750
# 3         AndrewLuck  97.0125
# 52          MattRyan  96.0000

qb2012t2014 = data.table(qb[which(qb$Season %in% c("2014", "2013", "2012")), ])

qb2012t2014rat = aggregate(qb2012t2014$QBRat, by=list(qb2012t2014$Name), 
	FUN=mean)
	
qb2012t2014rato = qb2012t2014rat[order(qb2012t2014rat$x, 
	decreasing = TRUE), ]

#when you look over the last 6 years, the numbers make more sense 

# > head(qb2012t2014rato, 10 )
#              Group.1         x
# 74     PeytonManning 108.41042
# 1       AaronRodgers 108.00244
# 97          TonyRomo 101.70435
# 32         DrewBrees 101.41458
# 77     RussellWilson  98.48750
# 75      PhilipRivers  97.48542
# 6  BenRoethlisberger  96.92667
# 68          MattRyan  96.56875
# 98      TrentEdwards  95.80000
# 2          AlexSmith  95.56250




