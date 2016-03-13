//from https://github.com/stan-dev/example-models/blob/master/misc/gaussian-process/gp-sim.stan
data {
  int<lower=1> N;
  real x[N];
}
transformed data {
  vector[N] mu;
  cov_matrix[N] Sigma;
  for (i in 1:N)
    mu[i] <- 0;
  for (i in 1:N)
    for (j in 1:N)
      Sigma[i,j] <- exp(-pow(x[i] - x[j], 2)) + if_else(i==j, 0.01, 0.0);
}
parameters {
  vector[N] y;
}
model {
  y ~ multi_normal(mu, Sigma);
}
