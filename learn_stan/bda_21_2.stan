data {
  int<lower=1> N;
  real age[N];
  vector[N] know;
}
transformed data {
  vector[N] mu;
  cov_matrix[N] Sigma;
  for (i in 1:N) mu[i] <- 0;
  for (i in 1:N)
    for (j in 1:N)
      Sigma[i,j] <- exp(-pow(know[i] - know[j],2))
        + if_else(i==j, 0.1, 0.0);
}
parameters {
  vector[N] y;
}
model {
  y ~ multi_normal(mu, Sigma);
  // for (n in 1:N)
  //   [n] ~ (y[n]);
}
// generated quantities {
//   vector[N] y;
//   for(i in 1:N)
//
// }
