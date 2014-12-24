library(ggplot2)

nutrition = read.table("/Users/amckenz/Dropbox/learn_R/plots/nutrition_fd_data.txt", sep = '\t', 
header = TRUE, row.names = NULL, fill = TRUE, quote = "")

a = ggplot(nutrition, aes(x=Calories_Per_Dollar, y= True_Cals_GL_Ratio))+
geom_point(aes(colour=factor(nutrition$Group))) + theme_bw() + 
geom_text(label = nutrition$Food,  size = 4, vjust=-0.6) + 
scale_x_continuous(name = "Calorie to Cost (in $) Ratio", limits = c(0,600)) +
scale_y_continuous(name="Calorie to Glycemic Load Ratio") + 
labs(colour="Food Type")

#may want to change size to map to popularity of the food 