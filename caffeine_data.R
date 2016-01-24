#http://www.sciencedirect.com/science/article/pii/S0278691513007175
#mean caffeine for all U.S. consumers = 190
#90th percentile for all U.S. consumers = 394
#assuming a log-normal distribution 

plot(x = seq(0.001, 0.99, 0.001), y = qlnorm(seq(0.001, 0.99, 0.001), 5.25, 0.57),
  ylim = c(0, 700), ylab = "Caffeine Consumed via Coffee",
  xlab = "U.S. Percentile")
