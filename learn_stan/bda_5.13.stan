data{
  int N; // number of blocks
  int res_bike_bikes[N]; // number of bikes
  int res_bike_other[N]; // number of other vehicles
}
transformed data{
  int res_bike_total[N];
  for(i in 1:N)
    res_bike_total[i] <- res_bike_bikes[i] + res_bike_other[i];
}
parameters{
  real<lower=0,upper=1> theta[N];
  real<lower=0> theta_hyper_alpha;
  real<lower=0> theta_hyper_beta;
}
model{
  theta_hyper_alpha ~ normal(0, 10);
  theta_hyper_beta ~ normal(0, 10);
  for(i in 1:N)
    theta[i] ~ beta(theta_hyper_alpha, theta_hyper_beta);
  res_bike_bikes ~ binomial(res_bike_total, theta);
}
