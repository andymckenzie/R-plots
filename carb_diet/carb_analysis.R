
library(dplyr)

carb_data = read.table("/Users/amckenz/Documents/github/R-plots/carb_diet/carb_diet_data.txt", 
	header = T, sep = " ", skip = 1)

carb_data = mutate(carb_data, FC_Ratio = Fat/Carb)	
carb_data = mutate(carb_data, FP_Ratio = Fat/Protein)	

#lm(carb_data$Median_life ~ carb_data$Energy + carb_data$Protein + carb_data$Carb + carb_data$Fat) 	
#lm(carb_data$Median_life ~ carb_data$Energy + carb_data$Protein + carb_data$Carb + carb_data$Fat + carb_data$PC_Ratio) 

lm(carb_data$Median_life ~ carb_data$Energy + carb_data$Protein + carb_data$Carb + carb_data$Fat + carb_data$PC_Ratio + carb_data$FC_Ratio) 

lm(carb_data$nMax_life ~ carb_data$Energy + carb_data$Protein + carb_data$Carb + carb_data$Fat + carb_data$PC_Ratio + carb_data$FC_Ratio) 

lm(carb_data$nMax_life ~ carb_data$Energy + carb_data$Protein + carb_data$Carb + carb_data$Fat + carb_data$PC_Ratio + carb_data$FC_Ratio + carb_data$FP_Ratio)