#copying from http://www.sumsar.net/blog/2014/03/bayesian-first-aid-pearson-correlation-test/

set.seed(42)

##########
# load the data for trait correlation

## Model code for the Bayesian First Aid alternative to Pearson's correlation test. ##
library(rjags)

if(!exists("gset")){
library(Biobase, quietly = FALSE)
library(GEOquery)
library(limma)

gset = getGEO("GSE54514", GSEMatrix =TRUE)
if (length(gset) > 1) idx = grep("GPL6947", attr(gset, "names")) else idx = 1
gset = gset[[idx]]

fvarLabels(gset) = make.names(fvarLabels(gset))

# group names for all samples
sml = c("X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G4","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G3","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G2","G1","G1","G1","G1","G1","G1","G1","G1","G1","G1","G1","G1","G1","G1","G0","G0","G0","G0","G0","G0","G0","G0","G0","G0","G0","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X","X");

# eliminate samples marked as "X"
sel = which(sml != "X")
sml = sml[sel]
gset = gset[ ,sel]

# log2 transform
ex = exprs(gset)
qx = as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC = (qx[5] > 100) ||
          (qx[6]-qx[1] > 50 && qx[2] > 0) ||
          (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
if (LogC) { ex[which(ex <= 0)] = NaN
  exprs(gset) = log2(ex) }

# set up the data and proceed with analysis
fl = as.factor(sml)
gset$description = fl
design_mat = model.matrix(~ description + 0, gset)
labels = c("Survive_Day5", "Survive_Day4", "Survive_Day3", "Survive_Day2",
	"Survive_Day1")
colnames(design_mat) = labels

####################
# library(ddcor)
}

GPL694 = read.delim("/Users/amckenz/Dropbox/zhang/diffcorr/GPL6947-13512.txt")
CSGALNACT1_id = GPL694$ID[which(GPL694$Symbol %in% "CSGALNACT1")]
EPHB1_id = GPL694$ID[which(GPL694$Symbol %in% "EPHB1")]

#fer is not in this data set...

#which(rownames(ex) %in% CSGALNACT1_id) #20415
# which(rownames(ex) %in% "ILMN_1692261")
# [1] 4687
ex_sub = ex[c(4687, 20415), ]
groups = as.numeric(gset$description)

#pairs(data.frame(ex_sub[,c(1:nvars)], Y[,c(1:nvars)], Z[,c(1:nvars)]))

# Initializing the data list and setting parameters for the priors
# that in practice will result in flat priors on mu and sigma.
data_list = list(
  xy = t(ex_sub),
  n = length(ex_sub[1,]),
  group = groups,
  nCond = 5,
  mean_mu = mean(c(ex_sub), trim=0.2) ,
  mean_rho = 0,
  precision_rho = 0.00001,
  precision_mu = 1 / (max(mad(ex_sub[1,]), mad(ex_sub[2,]))^2 * 1000000),
  sigmaLow = max(mad(ex_sub[1,]), mad(ex_sub[2,])) / 1000 ,
  sigmaHigh = min(mad(ex_sub[1,]), mad(ex_sub[2,])) * 1000)


# The model string written in the JAGS language
model_string <- "model {
  for(i in 1:n) {
    xy[i,1:2] ~ dmt(mu[,group[i]], prec[,,group[i]], nu)
  }

	for(j in 1:nCond){
	  cov[1,1,j] <- sigma[1] * sigma[1]
	  cov[1,2,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,1,j] <- sigma[1] * sigma[2] * rho[j]
	  cov[2,2,j] <- sigma[2] * sigma[2]
	  #rho[j] ~ dunif(-1, 1)
    #can't have negative values here bc it will not be a positive definite matrix? ...
    rho[j] ~ dnorm(mean_rho, precision_rho)T(-1,1)
    #or maybe could extend the beta distribution for the prior? but below doesn't work
    #rho_s[j] ~ dnorm(a, b)T(-1, 1)
    # rho_s[j] ~ dbeta(a, b)
    # rho[j] <- rho_s[j] * 2 - 1
    mu[1,j] ~ dnorm(mean_mu, precision_mu)
	  mu[2,j] ~ dnorm(mean_mu, precision_mu)
    # JAGS parameterizes the multivariate t using precision (inverse of variance)
    # rather than variance, therefore we must invert the covariance matrices.
    prec[1:2,1:2,j] <- inverse(cov[,,j])
	}

  ## Priors
  #a ~ dunif(-1, 1)
  # a ~ dbeta(1, 1)
  # mean_rho_beta <- a * 2 - 1
  # b ~ dbeta(1, 1)
  sigma[1] ~ dunif(sigmaLow, sigmaHigh)
  sigma[2] ~ dunif(sigmaLow, sigmaHigh)
  nu <- nuMinusOne+1
  nuMinusOne ~ dexp(1/29)
}"

# Initializing parameters to sensible starting values helps the convergence
# of the MCMC sampling. Here using robust estimates of the mean (trimmed)
# and standard deviation (MAD).

# Running the model
#inits = inits_list,
model <- jags.model(textConnection(model_string), data = data_list,
                    n.chains = 3, n.adapt = 15000)
update(model, 500) # Burning some samples to the MCMC gods....

# The parameters to monitor.
params <- c("rho", "mu", "sigma", "nu")
samples <- coda.samples(model, params, n.iter = 1000)

# Inspecting the posterior
plot(samples)
summary(samples)

#add direct comparisons of the posterior add different time points
rho_d1 <- unlist(samples[ , "rho[1]"])
rho_d2 <- unlist(samples[ , "rho[2]"])
rho_d3 <- unlist(samples[ , "rho[3]"])
rho_d4 <- unlist(samples[ , "rho[4]"])
rho_d5 <- unlist(samples[ , "rho[5]"])

plot(density(rho_d5 - rho_d1), main = "Difference in Rho Day 5 versus Day 1", xlab = "Posterior Difference in MCMC Chain Step")
plot(density(rho_d4 - rho_d1), main = "Difference in Rho Day 4 versus Day 1", xlab = "Posterior Difference in MCMC Chain Step")
