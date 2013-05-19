#Rscript to make a bubble plot
#note that in order to make the size, not the radius of the circles proportional to the probability, you need to take the sqrt of the probability
#as a result of this, you also need to adjust the breaks and labels in the legend so that they correspond to the true rather than transformed probability

library(ggplot2)

ggplot(data, aes(x=1.5*Gram, y= log(Cefotax_MIC), size=(sqrt(Prob)), label=Name))+
scale_x_discrete(name="Gram Stain of Organism", labels = c("Negative", "Variable", "Positive"), limits = c(0, 1.5, 3))+ 
scale_y_continuous(name = "Log Resistance (MIC) to Cefotaxime") + geom_point(colour="red")+ 
theme(axis.text = element_text(size= 12, colour = "black"), axis.title = element_text(size = rel(1), colour = "blue"), legend.background = element_rect(colour="black", fill = "white"), legend.key = element_rect(fill = "white"), panel.background = element_rect(colour = "black", fill = "white"), panel.grid.major.x= element_blank())+
expand_limits(x = c(-0.75, 3.5)) + geom_text (size = 4, vjust=-0.3)+
scale_size_continuous(name = "Probability", range=c(2.5,25), breaks = c(0.1,0.1414, 0.2236, 0.31621, 0.5477, 0.7071,1), labels = c(0.01,0.02, 0.05, 0.10, 0.30, 0.50, 1.00), limits = c(0.1, 1))
