data{
  int N;
  int nGroup;
  real sleep_data[N];
  int pill_type[N];
}
parameters{
  real mu[nGroup];
  real<lower=0> sigma[nGroup];
  real prior_mu;
  real<lower=0> prior_sigma;
}
model{
  for(i in 1:nGroup)
    mu[i] ~ student_t(3, prior_mu, 2);
  for(i in 1:nGroup)
    sigma[i] ~ student_t(3, prior_sigma, 2);
  for(i in 1:N)
    sleep_data[i] ~ student_t(3, mu[pill_type[i]], sigma[pill_type[i]]);
}
