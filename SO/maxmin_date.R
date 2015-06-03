
dates = read.table("/Users/amckenz/Documents/github/R-plots/SO/date_data.txt")

#get differences in terms of the months and dates only 
compare_dates_days <- function(date1, date2, date_format = "%Y-%m-%d"){
	
	#give them all "blank" years of "00"
	month_day_only1 = paste("00", strsplit(date1,  "-")[[1]][2], strsplit(date1,  "-")[[1]][3], sep = "-")
	month_day_only2 = paste("00", strsplit(date2,  "-")[[1]][2], strsplit(date2,  "-")[[1]][3], sep = "-")
	
	day_difference = as.numeric(as.Date(as.character(month_day_only1, format = "%m-%d")) -
		as.Date(as.character(month_day_only2, format = "%m-%d")))
	
	return(day_difference)
	
}

#testing the above function 
a = "2009-02-14"
b = "2009-02-28"
diff = compare_dates_days(a, b)

min_abs_index <- function(v){
	
  v.na = abs(v)
  v.na[v==0] = NA
  return(c( which.min(v.na) ))
  
}

above_below_year_date <- function(date, date_ref_compare, date_format = "%Y-%m-%d"){
	
	one_year_ahead_diffs = rep(0, length(date_ref_compare))
	one_year_behind_diffs = rep(0, length(date_ref_compare))
	
	date_diffs = unlist(lapply(seq_along(1:length(date_ref_compare)),
		function(i) compare_dates_days(date_ref_compare[i],date )))
	
	for(i in 1:length(date_ref_compare)){
		#calendar year ahead
		if(as.numeric(sapply(strsplit(date, "-"),"[[", 1)) - 
			as.numeric(sapply(strsplit(date_ref_compare[i], 
			"-"),"[[", 1)) == 1){
			one_year_ahead_diffs[i] = date_diffs[i]
		}
		#calendar year behind
		if(as.numeric(sapply(strsplit(date, "-"),"[[", 1)) - 
			as.numeric(sapply(strsplit(date_ref_compare[i], 
			"-"),"[[", 1)) == -1){
			one_year_behind_diffs[i] = date_diffs[i]
		}
	}
	
	res_ahead = min_abs_index(one_year_ahead_diffs)
	print(res_ahead)
	print(one_year_ahead_diffs[res_ahead])
	
	print(one_year_ahead_diffs)
	
	res_behind = min_abs_index(one_year_behind_diffs)
	
	return(c(res_ahead, res_behind))

}

vector_of_ahead_indices = rep(0, length(dates$date))
vector_of_behind_indices = rep(0, length(dates$date))

for(i in 1:length(dates$date)){
	res = above_below_year_date(dates$date[i], dates$date)
	vector_of_ahead_indices[i] = res[1]
	vector_of_behind_indices[i] = res[2]
}

dates$nearest_val_nextyear = dates$value[vector_of_behind_indices]
dates$nearest_val_prevyear = dates$value[vector_of_ahead_indices]

#order to make it easier to manually check 
dates = dates[order(dates$date), ] 

#reorder the first year 
dates[1, "nearest_val_nextyear"] = dates[1, "nearest_val_prevyear"]
dates[1, "nearest_val_prevyear"] = NA
