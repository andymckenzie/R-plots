library(readxl)

data = read_excel("/Users/amckenz/Desktop/ff_week9.xlsx")

data_a = data[!is.na(data$Owner), ]

ggplot(data_a, aes(x = W, y = PF, label=Owner))+
  geom_point() +geom_text(aes(label=Owner),hjust=0.5, vjust=0, size = 3.5) + theme_bw() + ylab("Points For") + xlab("Wins") + geom_smooth(method = "lm", level = 0.8)