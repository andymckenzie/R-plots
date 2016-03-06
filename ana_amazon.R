library(ggplot2)

ama = read.csv("01-Jan-2007_to_06-Mar-2016.csv", comment.char = "")

ama$Item.Total = gsub("$", "", ama$Item.Total, fixed = TRUE)
ama$Item.Total = as.numeric(ama$Item.Total)


#order by cost
ama = ama[order(ama$Item.Total, decreasing = TRUE), ]

#
cats = table(ama$Category)
cats = cats[!names(cats) == ""]

plot_cats = data.frame(nums = as.numeric(cats), cats = names(cats))

ggplot(plot_cats, aes(x = cats, y = nums)) + geom_bar() + coord_flip() + theme_bw()
