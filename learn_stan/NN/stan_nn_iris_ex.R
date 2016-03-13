#from herra huu here: https://groups.google.com/forum/#!topic/stan-users/3QBBpo11Lus
library(rstan)

setwd("/Users/amckenz/Documents/github/R-plots/learn_stan/NN/")

data = iris[1:100,]
data[,1:4] = scale(data[,1:4])
data[,5] = as.integer(data[,5])-1

switch_to_regression = TRUE
if(switch_to_regression == TRUE){
  data[,5] = c(rnorm(50, -1, 0.1), rnorm(50, 1, 0.1))
}

N = 80
Nt = nrow(data)-N
train_ind = sample(100,N)
test_ind = setdiff(1:100, train_ind)

yt = data[test_ind,5]
mcmc_data=list(
  num_nodes=10,
  num_middle_layers=5,
  d=4,
  N=N,
  Nt=Nt,
  X=data[train_ind,1:4],
  y=data[train_ind,5],
  Xt=data[test_ind,1:4])

m <- stan_model("stan_nn_iris_ex.stan")
s <- sampling(m, data = mcmc_data, iter = 300, chains = 1)

fitmat = as.matrix(s)
predictions = fitmat[,grep("predictions", colnames(fitmat))]
beta_parameters = fitmat[,grep("beta", colnames(fitmat))]
alpha_parameters = fitmat[,grep("alpha", colnames(fitmat))]

mean_predictions = colMeans(alpha_parameters)
plot(1:Nt, yt)
lines(1:Nt, mean_predictions, type='p', col='red')
