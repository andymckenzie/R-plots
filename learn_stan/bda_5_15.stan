data{
  int N;
  real log_odds[N];
  real odds_sd[N];
}
parameters{
  real theta[N];
  real<lower=-10,upper=10> mu; // uniform distributed by default
  real<lower=0> tau;
}
model{
  tau ~ cauchy(0, 25);
  theta ~ normal(mu, tau);
  log_odds ~ normal(theta, odds_sd);
}
