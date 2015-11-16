
lol = read.table("MBP_laugh_data.txt")

lol_dstn = lol$V1

hist(lol_dstn, breaks = 24, col = "cyan", xlab = "Page Number", 
	ylab = "Number of LOLs in Margin", main= "The Mind Body Problem Laughter Chart", 
	xlim = c(0, 275)) 