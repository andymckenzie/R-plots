#see whether lm is the same as corr, which it should be 

set.seed(42)

a = runif(0, 1, n = 10)
b = runif(0, 1, n = 10)

cor(a,b)

lm(as.matrix(a) ~ as.matrix(b) + 0)
#not the same

a1 = scale(a)
b1 = scale(b)

lm(a1 ~ b1 + 0)

#nb that correlation is only the same as regression when you scale the variables ... 