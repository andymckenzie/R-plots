a=read.table("/Users/amckenz/Documents/github/R-plots/gr_laughs.txt", header = F)

points = seq(1,50,1)

plot(hist(a$V2), ylim = c(0, 7), xlim = c(0,50), 
	xlab = "Number of Laughs in a 40 Page Section") 

lines(75*(dpois(points, mean(a$V2))))

#plot(a$V2) 