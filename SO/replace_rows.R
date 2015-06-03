

#read in csv file
data = read.csv("/Users/amckenz/Documents/github/R-plots/SO/replace_data.txt", fill = T, na.strings = "")

replace_missing_info <- function(data_df, column_with_blanks, 
	primary_replacement_column, secondary_replacement_column){
	
	for(i in 1:nrow(data_df)){
		if(is.na(data_df[i, column_with_blanks])){
			if(!is.na(data_df[i, primary_replacement_column])){
				data_df[i, column_with_blanks] = data_df[i, primary_replacement_column]
			} else if(!is.na(data_df[i, secondary_replacement_column])){
				data_df[i, column_with_blanks] = data_df[i, secondary_replacement_column]
			}
		}
	}
	
	return(data_df)
	
}

updated_data = replace_missing_info(data_df = data, "Old.Info", "New.Info", "Secondary.Replacement.Info")