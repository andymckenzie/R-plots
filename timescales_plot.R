
library(ggplot2)
library(readxl)
library(bayesbio)
library(grid)
library(gtable)

##########
cognitive_data = read_excel("/Users/amckenz/Downloads/cognitive_processes.xlsx")

cognitive_data = cognitive_data[order(cognitive_data$Mean_Timescale_ns, decreasing = TRUE), ]
cognitive_data$Process = factor(cognitive_data$Process, levels = cognitive_data$Process)

cognitive_plot = ggplot(cognitive_data, aes(y = Process, x = log(Mean_Timescale_ns, 10), colour = Category))
cognitive_plot = cognitive_plot + geom_point() + theme_bw() +
  geom_errorbarh(aes(xmax = log(Max_Timescale_ns, 10),
    xmin = log(Min_Timescale_ns, 10), height = .2)) + xlab("Timescale") + ylab("") +
    scale_x_continuous(breaks = c(-3,0,3,6,9, log(1e9*60, 10), log(1e9*60*60, 10), log(1e9*60*60*24, 10)),
    labels = c("Picoseconds", "Nanoseconds", "Microseconds", "Milliseconds",
      "Seconds", "Minutes", "Hours", "Days"), limits = c(-3.5, 14))

###########

neural_data = read_excel("/Users/amckenz/Downloads/neural_processes.xlsx")

#put all of the data on the timescale of seconds
neural_data = neural_data[!is.na(neural_data$Mean_Timescale_ns), ]

neural_data$Process_search = gsub("Protein conformation ", "conformation", neural_data$Process)
neural_data$Process_search = gsub("Transcription of 1000 bp RNA", "Transcription", neural_data$Process_search)
neural_data$Process_search = gsub("Translation of 333 AA protein", "Translation", neural_data$Process_search)
neural_data$Process_search = gsub("Action potential at local membrane", "action potential", neural_data$Process_search)
neural_data$Process_search = gsub("Calcium-triggered NT release", "calcium neurotransmitter", neural_data$Process_search)

neural_data = neural_data[order(neural_data$Mean_Timescale_ns, decreasing = TRUE), ]
neural_data$Process_search = factor(neural_data$Process_search, levels = neural_data$Process_search)

neural_plot = ggplot(neural_data, aes(y = Process_search, x = log(Mean_Timescale_ns, 10), colour = Category))
neural_plot = neural_plot + geom_point() + theme_bw() +
  geom_errorbarh(aes(xmax = log(Max_Timescale_ns, 10),
    xmin = log(Min_Timescale_ns, 10), height = .2)) + xlab("Timescale") + ylab("") +
    scale_x_continuous(breaks = c(-3,0,3,6,9, 10.77815, 12.5563, 13.93651, 15.41363, 16.4988, 17.49881),
    labels = c("Picoseconds", "Nanoseconds", "Microseconds", "Milliseconds",
      "Seconds", "Minutes", "Hours", "Days", "Months", "Years", "Decades"), limits = c(-3.5, 14))

gb1 = ggplot_build(cognitive_plot)
gb2 = ggplot_build(neural_plot)

gA = ggplot_gtable(gb1)
gB = ggplot_gtable(gb2)

g = gtable:::rbind_gtable(gA, gB, size = "last")

grid.newpage()
grid.draw(g)
