
#http://stackoverflow.com/a/14721124/560791
latemail <- function(N, st="2010/01/01", et="2030/12/31") {
  st = as.POSIXct(as.Date(st))
  et = as.POSIXct(as.Date(et))
  dt = as.numeric(difftime(et,st,unit="sec"))
  ev = sort(runif(N, 0, dt))
  rt = st + ev
}

df1 = data.frame(a = latemail(100), b = runif(100, 1, 5))
df2 = data.frame(a = latemail(100), b = runif(100, 1, 5))

df1 = data.frame(a = as.POSIXct(c("2010/05/01", "2010/05/10", "2010/05/30")), b = c(3, 4, 5))
df2 = data.frame(c = as.POSIXct(c("2010/05/02", "2010/05/03", "2010/05/21", "2010/05/02")), d = c(1, 2, 3, 4))

#' @param df1 Data frame containing the dates for which the differences between the other data frame's date column should be minimized for each row.
#' @param df2 Data frame containing the dates which should be compared to, as well as other values that should be merged to df1 per minimized date time.
#' @param timeCol1 Character vector specifying the date/time column in df1.
#' @param timeCol2 Character vector specifying the date/time column in df2.
nearestTime <- function(df1, df2, timeCol1, timeCol2){
  if(!timeCol1 %in% colnames(df1)) stop("timeCol1 must specify a column name in df1.")
  if(!timeCol2 %in% colnames(df2)) stop("timeCol2 must specify a column name in df2.")
  dfMinTime <- data.frame(matrix(ncol = (ncol(df2) - 1), nrow = nrow(df1)))
  ties_count = 0
  for(i in 1:nrow(df1)){
      min_row = numeric()
      min_rows = apply(df2, 1, function(x) abs(as.numeric(difftime(df1[i, timeCol1], x[timeCol2]))))
      mins = (min_rows == min(min_rows))
      if(sum(mins) > 1) { ties_count = ties_count + 1 }
      df_to_add[i, ] = df2[which.min(min_rows), !(colnames(df2) %in% timeCol2), drop = FALSE]
      print(min_rows)
      print(whichmin_rows))
  }
  dfAll = cbind(df1, dfMinTime)
  if(ties_count > 0){
    message("Warning: there were ", ties_count, " difftime ties, for which the first row of df2 was chosen.")
  }
  return(dfAll)
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
