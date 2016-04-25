#following from http://blog.yhat.com/posts/10-R-packages-I-wish-I-knew-about-earlier.html
#very cool time series/QC plot 

library(qcc)

x = cbind(rnorm(100, 10, 1), rnorm(100, 10, 1), rnorm(100, 10, 1))

qcc(x, type="xbar.one")
