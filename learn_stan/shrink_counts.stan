data{
  int N;
  int hits[N];
  int atbats[N];
}
parameters{
  real<lower=0,upper=1> probs[N];
  real<lower=0,upper=1> prior_average;
  real prior_atbats;
}
transformed parameters{
  real prior_hits;
  real prior_outs;
  prior_hits <- prior_average * prior_atbats;
  prior_outs <- (1 - prior_average) * prior_atbats;
}
model{
  prior_average ~ beta(1, 1);
  prior_atbats ~ pareto(1.5, 1);
  for(i in 1:N)
    probs[i] ~ beta(prior_hits, prior_outs);
  hits ~ binomial(atbats, probs);
}
