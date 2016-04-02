#different forms of lm, from http://r.789695.n4.nabble.com/very-fast-OLS-regression-td884832.html
#shows that lm.fit is a pretty good trade btwn speed and interpretability, but may also want to try qr() or crossprod()

ols1 <- function (y, x) {
     coef(lm(y ~ x - 1))
}

ols2 <- function (y, x) {
     xy <- t(x)%*%y
     xxi <- solve(t(x)%*%x)
     b <- as.vector(xxi%*%xy)
     b
}

ols3 <- function (y, x) {
     XtX <- crossprod(x)
     Xty <- crossprod(x, y)
     solve(XtX, Xty)
}

ols4 <- function (y, x) {
     lm.fit(x, y)$coefficients
}

ols5 <- function( y, x, tol=1.e-07 ) {
      qr.x <- qr(x, tol=tol, LAPACK=TRUE)
      b <- qr.coef(qr.x, y)
      ## I will need these later, too:
      ## res<- qr.res(qr.x, y)
      ## soa[i]<-b[2]
      ## sigmas[i]<-sd(res)
      b;
}

# check timings
MC <- 500
N <- 10000

set.seed(0)
x <- matrix(rnorm(N*MC), N, MC)
y <- matrix(rnorm(N*MC), N, MC)

invisible({gc(); gc(); gc()})
system.time(for (mc in 1:MC) ols1(y[, mc], x[, mc]))

invisible({gc(); gc(); gc()})
system.time(for (mc in 1:MC) ols2(y[, mc], x[, mc]))

invisible({gc(); gc(); gc()})
system.time(for (mc in 1:MC) ols3(y[, mc], x[, mc]))

invisible({gc(); gc(); gc()})
system.time(for (mc in 1:MC) ols4(y[, mc], x[, mc, drop = FALSE]))

invisible({gc(); gc(); gc()})
system.time(for (mc in 1:MC) ols5(y[, mc], x[, mc]))
