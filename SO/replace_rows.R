

#read in csv file
data = read.csv("/Users/amckenz/Documents/github/R-plots/SO/replace_data.txt", fill = T, na.strings = "")

replace_missing_info <- function(data_df){
	
	for(i in 1:nrow(data_df)){
		print(i)
		if(is.na(data_df[i, 1])){
			if(!is.na(data_df[i, 2])){
				data_df[i, 1] = data_df[i, 2]
			} else if(!is.na(data_df[i, 3])){
				data_df[i, 1] = data_df[i, 3]
			}
		}
	}
	
	return(data_df)
	
}

updated_data = replace_missing_info(data_df = data)