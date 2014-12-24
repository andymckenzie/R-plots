library(Rcpp)

cppFunction('bool eval_all(LogicalVector x) {
  int n = x.size();
  
  for(int i = 0; i < n; ++i) {
      if (!x[i]) return false;
    }
  
  return true;
}')
