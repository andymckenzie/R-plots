library(googleVis)

#example from the vignette
data(Fruits)

M = gvisMotionChart(Fruits, idvar="Fruit", timevar="Year")

plot(M)
