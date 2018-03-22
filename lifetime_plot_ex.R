
library(ggplot2)
library(readxl)
library(bayesbio)
library(grid)
library(gtable)

cognitive_data = read_excel("/Users/mckena01/Dropbox/bpf/bp_papers/timescales/Example_Cognitive_Lifetime.xlsx")
cognitive_data = cognitive_data[rev(order(cognitive_data$Min_Timescale_ns)), ]
cognitive_data$Rank = 1:nrow(cognitive_data)

p = ggplot(cognitive_data, aes(y = Rank, x = log(Mean_Timescale_ns, 10)))
p = p + geom_point() + theme_classic() + theme(legend.position = "none") +
  geom_errorbarh(aes(xmax = log(Max_Timescale_ns, 10),
    xmin = log(Min_Timescale_ns, 10), height = 0.25)) + xlab("Lifetime (Log)") + ylab("Cognitive Process") +
    scale_x_continuous(breaks = c(6,9, 10.77815, 12.5563, 13.93651, 15.41363, 16.4988, 17.49881),
    labels = c("Milliseconds", "Seconds", "Minutes", "Hours", "Days", "Months", "Years",
      "Decades"), limits = c(5.5, 18.5)) +
      scale_y_continuous(breaks = c(1, 2, 3, 4),
      labels = c("D", "C", "B", "A"),
      limits = c(0.7, 4.3))

neural_data = read_excel("/Users/mckena01/Dropbox/bpf/bp_papers/timescales/Example_Neural_Lifetime.xlsx")
neural_data = neural_data[rev(order(neural_data$Min_Timescale_ns)), ]
neural_data$Rank = 1:nrow(neural_data)

neural_plot = ggplot(neural_data, aes(y = Rank, x = log(Mean_Timescale_ns, 10)))
neural_plot = neural_plot + geom_point() + theme_classic() + theme(legend.position = "none") +
  geom_errorbarh(aes(xmax = log(Max_Timescale_ns, 10),
    xmin = log(Min_Timescale_ns, 10), height = 0.25)) + xlab("Lifetime (Log)") + ylab("Neural Process") +
    scale_x_continuous(breaks = c(6,9, 10.77815, 12.5563, 13.93651, 15.41363, 16.4988, 17.49881),
    labels = c("Milliseconds", "Seconds", "Minutes", "Hours", "Days", "Months", "Years",
      "Decades"), limits = c(5.5, 18.5)) +
      scale_y_continuous(breaks = c(1, 2, 3, 4, 5),
      labels = c("E", "D", "C", "B", "A"),
      limits = c(0.7, 5.3))

checkbox = data.frame(Neural = rep(LETTERS[1:5], each = 4),
                   Cognitive = rep(LETTERS[1:4], times = 5),
                   value = c(1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1))

checkbox$value = gsub(1, "+", checkbox$value)  #✓
checkbox$value = gsub(0, "-", checkbox$value)  #✓
checkbox = checkbox[seq(nrow(checkbox),1),]
checkbox$Cognitive = ordered(checkbox$Cognitive, levels = sort(unique(checkbox$Cognitive)))
checkbox$Neural = ordered(checkbox$Neural, levels = rev(sort(unique(checkbox$Neural))))

check_plot = ggplot(checkbox, aes(x = Cognitive,
                      y = Neural,
                      fill = value)) +
    geom_tile() +
    geom_text(label = checkbox$value, size = 4, colour = "black") +
    scale_fill_manual(values = c("hotpink1", "lightgreen")) +
    theme(legend.position = "none") + ylab("Neural Process") + xlab("Cognitive Process") +
    theme(panel.grid.minor = element_blank()) +
    theme(axis.ticks = element_blank()) +
    theme(panel.background = element_rect(fill = "transparent"))

gb1 = ggplot_build(p)
gb2 = ggplot_build(neural_plot)
gb3 = ggplot_build(check_plot)

gA = ggplot_gtable(gb1)
gB = ggplot_gtable(gb2)
gC = ggplot_gtable(gb3)

g1 = gtable:::rbind_gtable(gA, gB, size = "last")
g2 = gtable:::rbind_gtable(g1, gC, size = "last")

grid.newpage()
grid.draw(g2)
