#include <Rcpp.h>
using namespace Rcpp;

// test comment

// [[Rcpp::export]]
double varC(NumericVector x) {
  int n = x.size();
  
  if(n == 0){
	  return 0; 
  }
  
  double K = x[0];
  double Sum = 0;
  double Sum_sqr = 0;

  for(int i = 0; i < n; ++i) {
    Sum += (x[i] - K);
	Sum_sqr += ((x[i] - K) * (x[i] - K));
  }
  
  double variance = (Sum_sqr - (Sum * Sum)/n)/(n-1);
  
  return variance;
}

/*** R
library(microbenchmark)
x <- runif(1e5)
microbenchmark(
  var(x),
  varC(x)
)
*/