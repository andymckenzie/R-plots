#' Merges two data frames by finding the min time between a time column in each.
#' 
#' 

min_date_merge <- function(x, y, by.x, by.y, ...){
  
  
  
}

#merge the tables
dtim = merge(dti, mmse, by = "RID")

#find the difference in total days between the EXAMDATE from the DTI table and the USERDATE from MMSE table 
#mmse EXAMDATE has MANY missing mmse values; sum(is.na(dtim$EXAMDATE.y)); [1] 3646
#instead, will use USERDATE, which from an examination of the .csv file makes total sense
dtim$diffdate = as.numeric(difftime(strptime(dtim$EXAMDATE.x, 
	format = "%Y-%m-%d"), strptime(dtim$USERDATE, 
	format = "%Y-%m-%d"), units="days"))
#create a unique column value for merging purposes 
dtim$RID_date.x_difftime = paste(dtim$RID_date.x, abs(dtim$diffdate), sep = "_")

#for each RID/date unique point, choose the diffdate which minimizes it to find the nearest MMSE measurement 
mintime = aggregate(diffdate ~ RID_date.x, dtim, function(x) min(abs(x)))
#create a unique column value for merging purposes 
mintime$RID_date.x_difftime = paste(mintime$RID_date.x, abs(mintime$diffdate), 
	sep = "_")

#merge the tables to get the DTI + MMSE tables matched by only the times with the smallest deviations between dates 
dtim_mintime = merge(mintime, dtim, by = "RID_date.x_difftime")

library(DescTools)
dtim_mintime[AllDuplicated(dtim_mintime$RID_date.x.x), ]

first_dup = dtim_mintime[which(dtim_mintime$RID_date.x_difftime == "123_2013-03-21_32"), ]
identical(first_dup[1, ], first_dup[2, ])