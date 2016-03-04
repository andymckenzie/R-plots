data{
  int died1; // number of categories
  int total1;
  int died2;
  int total2;
}
parameters{
  real<lower=0,upper=1> theta1;
  real<lower=0,upper=1> theta2;
}
model{
  died1 ~ binomial(total1, theta1);
  died2 ~ binomial(total2, theta2);
}
generated quantities{
  real odds_ratio;
  odds_ratio <- (theta1/(1-theta1))/(theta2/(1-theta2));
}
