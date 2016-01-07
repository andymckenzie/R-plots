#from http://www.r-bloggers.com/fitting-mixture-distributions-with-the-r-package-mixtools/

library(mixtools)
wait = faithful$waiting
mixmdl = normalmixEM(wait)
plot(mixmdl,which=2)
#can add multiple lines with this function
lines(density(wait), lty=2, lwd=2)
