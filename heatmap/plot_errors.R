error_tracks = read.csv(file = "mckenzie_code_errors.csv", 
	sep = ",", header = TRUE, row.names = NULL)

dates = row.names(table(error_tracks$Date))

dates = as.Date(dates, "%m/%d/%Y")

entries = as.numeric(table(error_tracks$Date))

calendarHeat(dates, entries, varname="Recorded Errors")