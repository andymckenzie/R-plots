
###################################
#functions ####
psum <- function(..., na.rm=TRUE) { 
  x <- list(...)
  rowSums(matrix(unlist(x), ncol=length(x)), na.rm=na.rm)
} 

####################################
# load and clean data 

late14 = read.table("/Users/amckenz/Dropbox/random_research/life/table/Late\ Summer-Fall-Winter\ \'14\ -\ Sheet1.tsv", sep = '\t', header = TRUE, fill = TRUE, quote = "")

colnames(late14)[grep("X", colnames(late14))] = "Date"

late14$BS = psum(late14$Class...Meetings, late14$HW...Studying)
late14$Total_work = psum(late14$Reading...Researching, late14$Coding, late14$Writing, late14$Thinking...Discussing) 
late14$work_BS = psum(late14$BS, late14$Total_work)

early15 = read.table("/Users/amckenz/Dropbox/random_research/life/table/Winter-Spring\ \'15\ -\ Sheet1.tsv", sep = '\t', header = TRUE, fill = TRUE, quote = "")

early15$BS = psum(early15$Class...Meetings, early15$Benchwork..added.3.31., 
	early15$HW...Studying)
early15$work_BS = psum(early15$BS,
	early15$ModPoms..45.mins.on..aim.for.6...working.day.)

late15 = read.table("/Users/amckenz/Dropbox/random_research/life/table/Summer-Fall-Winter\ \'15\ \ -\ Sheet1.tsv", sep = '\t', fill = TRUE, quote = "", comment.char = "", header = TRUE)

late15$BS = psum(late15$HW...Studying, late15$Class...Meetings, 
	late15$Benchwork..added.3.31.)
late15$work_BS = psum(late15$BS,
	late15$ModPoms..45.mins.on..aim.for.6...working.day.)


##################################
# analyses of time in the phd so far

work = c(late14$Total_work, early15$ModPoms..45.mins.on..aim.for.6...working.day., 
	late15$ModPoms..45.mins.on..aim.for.6...working.day.)	
	
BS = c(late14$BS, early15$BS, late15$BS)

work_BS = c(late14$work_BS, early15$work_BS, late15$work_BS)

stress = c(late14$Stress.Level..1.10., early15$Stress.Level..1.10., late15$Stress.Level..1.10.)

chilling = c(late14$Chilling..max...10., early15$Chilling..max...10., 
	late15$Chilling..max...10.)

lab_activiies = c(late14$Lab.activity, early15$Lab.activity, late15$Lab.activity)

#socializing negatively correlated with stress (-0.06), stress positively correlated with work (0.25), socializing negatively correlated with work (-0.55)