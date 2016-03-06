data {
  int<lower=1> N;
  real x[N];
  vector[N] y;
}
transformed data {
  vector[N] mu;
  for (i in 1:N)
    mu[i] <- 0;
}
parameters{
  real<lower=0> beta1;
}
transformed parameters{
  cov_matrix[N] Sigma;
  for (i in 1:N)
    for (j in i:N)
      Sigma[i,j] <- beta1 * exp(-pow(x[i] - x[j],2))
        + if_else(i==j, 0.1, 0.0);
  for(i in 1:N)
    for(j in (i+1):N)
      Sigma[j, i] <- Sigma[i, j];
}
model {
  beta1 ~ cauchy(0, 5);
  y ~ multi_normal(mu, Sigma);
}
generated quantities{
  vector[N] predict;
  predict <- multi_normal_rng(mu, Sigma);
}
