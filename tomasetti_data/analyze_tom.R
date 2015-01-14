tom_data = read.table(file = "/Users/amckenz/Dropbox/zhang/journal_club/tomasetti_data.txt", 
	header = TRUE, sep = " ", row.names = NULL, fill = TRUE) 

normal_corr = cor(tom_data$Lifetime_Incidence, as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue))
 
log_corr = cor(log(tom_data$Lifetime_Incidence), log(as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue))) 
#= 0.8039286, reproducing the result from the paper 
#square this to get r^2
 
tom_data[tom_data$Lifetime_Incidence > 0.03, ] 

qplot(tom_data$Lifetime_Incidence, 
	as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue), 
	xlab = "Lifetime Cancer Incidence", 
	ylab = "Total SC Divisions Lifetime") + 
	theme_bw() + stat_smooth(method="lm",se=TRUE)

qplot(log(tom_data$Lifetime_Incidence), 
	log(as.numeric(tom_data$Total_SC_Divions_Lifetime_Tissue)), 
	xlab = "Lifetime Cancer Incidence", 
	ylab = "Total SC Divisions Lifetime") + 
	theme_bw() + stat_smooth(method="lm",se=TRUE) 
	
tom_data$ERS = log(tom_data$Lifetime_Incidence, 10) *
	log(tom_data$Total_SC_Divions_Lifetime_Tissue, 10) + 18.49 

kmean_tom = kmeans(tom_data$ERS, 2)

tom_data$cluster_status = kmean_tom$cluster

plot(sort(tom_data$ERS))