data {
  int<lower=1> N;
  real births[N];
}
transformed data{
  int N_one;
  N_one <- 0;
  for (n in 1:N)
    if (births[n] == 1)
      N_one <- N_one + 1;
}
parameters {
  real<lower=0,upper=1> prob;
}
model {
  // for(n in 1:N)
  //   births[i] ~ bernoulli(prob);
  N_one ~ binomial(N, prob);
}
