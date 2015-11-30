set.seed(42)

################
#following from http://www.johnmyleswhite.com/notebook/2010/08/20/using-jags-in-r-with-the-rjags-package/

library(rjags)

###################
#normal distribution with unknown mean and variance 

N = 1000
x = rnorm(N, 0, 5)	
							
model_string = "model {
	for (i in 1:N) {
		x[i] ~ dnorm(mu, tau)
	}
	mu ~ dnorm(0, .0001)
	tau <- pow(sigma, -2)
	sigma ~ dunif(0, 100)
}"

# Running the model
jags = jags.model(textConnection(model_string), 
	data <- list('x' = x, 'N' = N), n.chains = 4, n.adapt = 200)
	
update(jags, 1000)
 
jags.samples(jags,
             c('mu', 'tau'),
             1000)

rm(list=ls()) 

###################
#basic linear regression 

N = 1000
x = 1:N
epsilon = rnorm(N, 0, 1)
y = x + epsilon

model_string = "model {
	for (i in 1:N){
		y[i] ~ dnorm(y.hat[i], tau) 
		y.hat[i] <- a + b * x[i]
	}
	a ~ dnorm(0, .0001)
	b ~ dnorm(0, .0001)
	tau <- pow(sigma, -2)
	sigma ~ dunif(0, 100)
}
"
 
jags <- jags.model(textConnection(model_string),
                   data = list('x' = x,
                               'y' = y,
                               'N' = N),
                   n.chains = 4,
                   n.adapt = 100)
 
update(jags, 1000)
 
jags.samples(jags,
             c('a', 'b', 'tau'),
             1000)


