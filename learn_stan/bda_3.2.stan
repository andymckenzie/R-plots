data{
  int K; // number of categories
  int N;
  int pre_debate[N];
  int post_debate[N];
}
parameters{
  simplex[N] alpha1;
  simplex[N] alpha2;
}
model{
  for(i in 1:K)
    pre_debate ~ multinomial(alpha1);
  for(i in 1:K)
    post_debate ~ multinomial(alpha2);
}
