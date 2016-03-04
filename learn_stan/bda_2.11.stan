data{
  int N; // number of observations
  vector[N] observations; //observations
}
parameters{
  real<lower=0,upper=100> theta;
}
model{
  for(i in 1:N)
    observations[i] ~ cauchy(theta, 1);
}
