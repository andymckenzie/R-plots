tom_data = read.table(file = "/Users/amckenz/Dropbox/zhang/journal_club/tomasetti_data.txt", 
	header = TRUE, sep = " ", row.names = NULL, fill = TRUE) 

cor(tom_data$Lifetime_Incidence, as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue))
 
tom_data[tom_data$Lifetime_Incidence > 0.03, ] 

qplot(tom_data$Lifetime_Incidence, as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue), xlab = "Lifetime Cancer Incidence", ylab = "Total SC Divisions Lifetime") + theme_bw()

qplot(log(tom_data$Lifetime_Incidence), log(as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue)), xlab = "Lifetime Cancer Incidence", ylab = "Total SC Divisions Lifetime") + theme_bw()

#testing more changes