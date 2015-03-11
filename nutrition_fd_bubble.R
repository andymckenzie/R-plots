library(ggplot2)

nutrition = read.table("/Users/amckenz/Dropbox/learn_R/plots/nutrition_fd_data.txt", sep = '\t', 
header = TRUE, row.names = NULL, fill = TRUE, quote = "")

nutrition$Group = gsub(" ", "", nutrition$Group)

#alter points position a bit so you can see them better

nutrition[nutrition$Food == "Edam cheese", ]$Calories_Per_Dollar = 90
nutrition[nutrition$Food == "Butternut squash", ]$Calories_Per_Dollar = 90
nutrition[nutrition$Food == "Kale veggie burger", ]$Calories_Per_Dollar = 140
nutrition[nutrition$Food == "Tuna", ]$Calories_Per_Dollar = 50
nutrition[nutrition$Food == "Mixed nuts", ]$Calories_Per_Dollar = 195
nutrition[nutrition$Food == "Cheddar cheese ", ]$Calories_Per_Dollar = 230
nutrition[nutrition$Food == "Whey protein ", ]$Calories_Per_Dollar = 170
nutrition[nutrition$Food == "Manchego cheese", ]$Calories_Per_Dollar = 130

a = ggplot(nutrition, aes(x=Calories_Per_Dollar, y= True_Cals_GL_Ratio))+
geom_point(aes(colour=factor(nutrition$Group))) + theme_bw() + 
geom_text(label = nutrition$Food, size = 4, vjust=-0.5, hjust = -0.1,  
	position=position_jitter(width=0,height=0.00), angle = 43, size = 3) + 
scale_x_continuous(name = "Calorie to Cost (in $) Ratio", limits = c(0,600)) +
scale_y_continuous(name="Calorie to Glycemic Load Ratio", limits = c(0, 1.25)) + 
labs(colour="Food Type")

#may want to change size to map to popularity of the food 