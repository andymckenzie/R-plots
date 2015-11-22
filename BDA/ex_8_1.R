#simulate data for three biased coins 

set.seed(42)

coin1 = rbinom(100, size = 1, prob = 0.1)
coin2 = rbinom(200, size = 1, prob = 0.4)
coin3 = rbinom(400, size = 1, prob = 0.8)
coin4 = rbinom(20, size = 1, prob = 0.85) #expecting this one to be shrunken towards the mean 

y = c(coin1, coin2, coin3, coin4)
s = c(rep("coin1", times = length(coin1)), 
	rep("coin2", times = length(coin2)), 
	rep("coin3", times = length(coin3)), 
	rep("coin4", times = length(coin4)))
	
out = cbind(y, s)

#spit out the data as a csv 
write.csv(data.frame(out), file = "ex_8_1_data.csv", row.names = FALSE, quote = FALSE)