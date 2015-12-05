#following from http://www.ling.uni-potsdam.de/~vasishth/JAGSStanTutorial/SorensenVasishthMay12014.pdf

library(rjags)
library(lme4)
library(MASS)


##########################
# generating data 

new.df <- function(cond1.rt=600, effect.size=10,
	sdev=40,
	sdev.int.subj=10, sdev.slp.subj=10,
	rho.u=0.6,
	nsubj=10,
	sdev.int.items=10, sdev.slp.items=10,
	rho.w=0.6,
	nitems=10) {

	ncond <- 2
	subj <- rep(1:nsubj, each=nitems*ncond)
	item <- rep(1:nitems, nsubj, each=ncond)
	cond <- rep(0:1, nsubj*nitems)
	err <- rnorm(nsubj*nitems*ncond, 0, sdev)
	d <- data.frame(subj=subj, item=item,
	cond=cond+1, err=err)
	Sigma.u<-matrix(c(sdev.int.subj^2,
	rho.u*sdev.int.subj*sdev.slp.subj,
	rho.u*sdev.int.subj*sdev.slp.subj,
	sdev.slp.subj^2),nrow=2)
	Sigma.w<-matrix(c(sdev.int.items^2,
	rho.u*sdev.int.items*sdev.slp.items,
	rho.u*sdev.int.items*sdev.slp.items,
	sdev.slp.items^2),nrow=2)
	# Adding random intercepts and slopes for subjects:
	## first col. has adjustment for intercept,
	## secdon col. has adjustment for slope
	subj.rand.effs<-mvrnorm(n=nsubj,rep(0,ncond),Sigma.u)
	item.rand.effs<-mvrnorm(n=nitems,rep(0,ncond),Sigma.w)
	# re.int.subj <- rnorm(nsubj, 0, sdev.int.subj)
	re.int.subj <- subj.rand.effs[,1]
	d$re.int.subj <- rep(re.int.subj, each=nitems*ncond)
	# re.slp.subj <- rnorm(nsubj, 0, sdev.slp.subj)
	re.slp.subj <- subj.rand.effs[,2]
	d$re.slp.subj <- rep(re.slp.subj,
	each=nitems*ncond) * (cond - 0.5)
	# Adding random intercepts and slopes for items:
	# re.int.item <- rnorm(nitems, 0, sdev.int.items)
	re.int.item <- item.rand.effs[,1]
	d$re.int.item <- rep(re.int.item, nsubj, each=ncond)
	# re.slp.item <- rnorm(nitems, 0, sdev.int.items)
	re.slp.item <- item.rand.effs[,2]
	d$re.slp.item <- rep(re.slp.item, nsubj,
	each=ncond) * (cond - 0.5)
	d$rt <- (cond1.rt + cond*effect.size
	+ d$re.int.subj + d$re.slp.subj
	+ d$re.int.item + d$re.slp.item
	+ d$err)
	return(list(d,cor(re.int.subj,re.slp.subj),
	cor(re.int.item,re.slp.item)))
}

dat25 <- new.df(nsubj=25,nitems=16,rho.u=0.6,rho.w=0.6)
d25 <- dat25[[1]]
d25<-d25[,c(1,2,3,9)]
d25$x0<-ifelse(d25$cond==1,-0.5,0.5)
u_corr25 <- dat25[[2]]
w_corr25 <- dat25[[3]]

#####################
#preparing data for JAGS

dat25 <- list( subj = sort(as.integer(factor(d25$subj) )),
	item = sort(as.integer(factor(d25$item) )),
	rt = d25$rt,
	x0 = d25$x0,
	N = nrow(d25),
	J = length( unique(d25$subj) ),
	K = length( unique(d25$item) ))
	
model_string <- "
data
{
zero.u[1] <- 0
zero.u[2] <- 0
zero.w[1] <- 0
zero.w[2] <- 0
}
model
{
# Intercept and slope for each person,
# including random effects
for( j in 1:J )
{
u[j,1:2] ~ dmnorm(zero.u,invSigma.u)
pred_u[j,1:2] ~ dmnorm(zero.u,invSigma.u)
}
# Intercepts and slope by item
for( k in 1:K)
{
w[k,1:2] ~ dmnorm(zero.w,invSigma.w)
## predicted by item effects:
pred_w[k,1:2] ~ dmnorm(zero.w,invSigma.w)
}
# Define model for each observational unit
for( i in 1:N )
{
mu[i] <- ( beta[1] + u[subj[i],1] + w[item[i],1]) +
( beta[2] + u[subj[i],2] + w[item[i],2] ) * ( x0[i] )
rt[i] ~ dnorm( mu[i], tau.e )
## predicted RTs:
pred[i] ~ dnorm( mu[i], tau.e )
}
minimum <- min(pred)
maximum <- max(pred)
mean <- mean(pred)
# Fixed intercept and slope (uninformative)
beta[1] ~ dnorm(0.0,1.0E-5)
beta[2] ~ dnorm(0.0,1.0E-5)
# Residual variance
tau.e <- pow(sigma.e,-2)
sigma.e ~ dunif(0,15)
# variance-covariance matrix of subject ranefs
invSigma.u ~ dwish( R.u , 2 )
R.u[1,1] <- pow(sigma.a,2)
R.u[2,2] <- pow(sigma.b,2)
R.u[1,2] <- rho.u*sigma.a*sigma.b
R.u[2,1] <- R.u[1,2]
Sigma.u <- inverse(invSigma.u)
# varying intercepts, varying slopes
tau.a ~ dgamma(1.5, pow(1.0,-4))
tau.b ~ dgamma(1.5, pow(1.0,-4))
sigma.a <- pow(tau.a,-1/2)
sigma.b <- pow(tau.b,-1/2)
# variance-covariance matrix of item ranefs
invSigma.w ~ dwish( R.w, 2 )
R.w[1,1] <- pow(sigma.c,2)
R.w[2,2] <- pow(sigma.d,2)
R.w[1,2] <- rho.w*sigma.c*sigma.d
R.w[2,1] <- R.w[1,2]
Sigma.w <- inverse(invSigma.w)
# varying intercepts, varying slopes
tau.c ~ dgamma(1.5, pow(1.0,-4))
tau.d ~ dgamma(1.5, pow(1.0,-4))
sigma.c <- pow(tau.c,-1/2)
sigma.d <- pow(tau.d,-1/2)
# correlation
rho.u ~ dnorm(mu_rho.u,tau_rho.u)T(-1,1)
mu_rho.u ~ dunif(-1,1)
tau_rho.u ~ dgamma(1.5,10E-4)
# correlation
rho.w ~ dnorm(mu_rho.w,tau_rho.w)T(-1,1)
mu_rho.w ~ dunif(-1,1)
tau_rho.w ~ dgamma(1.5,10E-4)
}"

track.variables<-c("beta","sigma.e","sigma.a",
"sigma.b","rho.u","pred_u","pred_w")

sim_25_over.mod <- jags.model( textConnection(model_string),
data = dat25,
n.chains = 4,
n.adapt = 200000,quiet=T)

sim_25_over.res <- coda.samples(sim_25_over.mod,
var = track.variables,
n.iter = 50000,
thin = 20 )
