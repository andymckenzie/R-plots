data{
  int N; // number of data points
  real x[N];
}
parameters {
  real<lower=0> y_inv[N];
}
transformed parameters {
  real<lower=0> y[N];
  for(i in 1:N)
    y[i] <- 1 / y_inv[i]; // change
}
model {
  for(i in 1:N)
    increment_log_prob( -2 * log(y_inv[i]) ); // adjustment
  y ~ gamma(2,4);
  x ~ normal(y, 1);
}
