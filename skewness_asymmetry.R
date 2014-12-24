#as described here http://stats.stackexchange.com/questions/24853/can-somebody-offer-an-example-of-a-unimodal-distribution-which-has-a-skewness-of
library(ggplot2)

#load distribution 
x = c(1,2,3,4,5,6,7,8,9,10,10,10,10,11,11,11,11,12,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,31,30,29,28,27,26,25,24,24,23,23,23,23,22,22,22,22,21,21,21,20,20,20,20,19,19,19,19,18,18,17.73924322333169,17,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1)

#compute skewness
sum((x-mean(x))^3)/(length(x) * sd(x)^3)

#result should be -3.494103e-16

df = melt(x)

p = ggplot(df, aes(x = as.integer(rownames(df)), y = value))

p + geom_smooth(weight = 5) + geom_point() + ylab("Value") + xlab("Index") + theme_bw()