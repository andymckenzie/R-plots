#based on http://lingpipe-blog.com/2009/10/13/bayesian-counterpart-to-fisher-exact-test-on-contingency-tables/
#with MD/PhD retreat data from Mark Bailey 

n1 = 15 #number who don't want to return
y1 = 8 #sick no-returners
n2 = 47 #number who do want to return 
y2 = 13 #non-sick returners 

# SIMULATION
I = 100000 # simulations
theta1 = rbeta(I, y1+1, (n1-y1)+1)  
theta2 = rbeta(I, y2+1, (n2-y2)+1)
diff = theta1-theta2  # simulated diffs

# OUTPUT
quantiles = quantile(diff,c(0.005,0.025,0.5,0.975,0.995))
print(quantiles,digits=2)

print("Probability that people who got sick at retreat are less likely to want to return:")
print(mean(theta1>theta2))

# VISUALIZATION
#png(file="bayesContingency.png")
plot(density(diff),
     xlab="theta1 - theta2",
     ylab="p(theta1 - theta2 | y, n)",
     main="Posterior Simulation of Sick vs Non-Sick Non-Returners",
     ylim=c(0,8),
     frame.plot=FALSE,cex.lab=1.5,lwd=3,yaxt="no")
abline(v=quantiles[2], col="blue")
abline(v=quantiles[4], col="blue")
#dev.off()
