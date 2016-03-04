data{
  int N; // number of observations
  int deaths[N];
}
parameters{
  real<lower=0,upper=1500> theta;
  real<lower=0,upper=1500> mean_p;
  real<lower=0,upper=1500> scale;
}
model{
  for(i in 1:N)
    deaths[i] ~ poisson(theta);
  for(i in 1:N)
    deaths[i] ~ neg_binomial_2_log(mean_p, scale);
}
