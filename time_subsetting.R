#SO answer... the time/date thing is very clunky 
#http://stackoverflow.com/questions/35719935/sum-of-columns-of-dataframe-based-on-time-period-in-r/35726610#35726610

subset_last_year <- function(df, date, cols_to_sum = c("A", "B", "C")){
  date = as.POSIXct(date, format = "%d-%b-%y")
  df$Time_Difference = difftime(date, df$Month_Date, units = "weeks")
  df_last_year = df[df$Time_Difference > 0 & df$Time_Difference < 53, ]
  tmp_col_sum = colSums(df_last_year[ , cols_to_sum], na.rm = TRUE)
  return(tmp_col_sum)
}

#oddly you have to add days
df$Month_Date = paste0("01-", df$Month)
df$Month_Date = as.POSIXct(df$Month_Date, format = "%d-%b-%y")

#not worried about performance because the data set is not that large
dates = c("01-Jan-05", "01-Feb-05", "01-Mar-05")
res = data.frame()
for(i in 1:length(dates)){
  tmp = subset_last_year(df, dates[i])
  res = rbind(res, tmp)
}
rownames(res) = dates
colnames(res) = c("A", "B", "C")
