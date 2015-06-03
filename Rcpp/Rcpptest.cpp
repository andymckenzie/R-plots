#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
SEXP convolve3cpp(SEXP a, SEXP b) {
	Rcpp::NumericVector xa(a);
	Rcpp::NumericVector xb(b);
	int n_xa = xa.size(), n_xb = xb.size();
	int nab = n_xa + n_xb - 1;
	Rcpp::NumericVector xab(nab);
	for (int i = 0; i < n_xa; i++)
	for (int j = 0; j < n_xb; j++)
	xab[i + j] += xa[i] * xb[j];
	return xab;
}

/*** R
library(microbenchmark)
x <- runif(1e4)
y <- runif(1e4)
microbenchmark(
  convolve3cpp(x, y)
)
*/