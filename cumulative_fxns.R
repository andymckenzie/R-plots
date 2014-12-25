#looks like I was kind of wrong about what cummax et al do; see ?cummax for more; leaving this for now, though

library(Rcpp)

cppFunction('int cum_prod(NumericVector x) {
  int n = x.size();
  int size = 0; 
  
  for(int i = 0; i < n; ++i) {
      size += x[i];
    }
  
  return size;
}')

cppFunction('int cum_min(NumericVector x) {
  int n = x.size();
  int min = x[0]; 
  
  for(int i = 1; i < n; ++i) {
	  if(x[i] < min){
	  	min = x[i]; 
	  }
    }
  
  return min;
}')

cppFunction('int cum_max(NumericVector x) {
  int n = x.size();
  int max = x[0]; 
  
  for(int i = 1; i < n; ++i) {
	  if(x[i] > max){
	  	max = x[i]; 
	  }
    }
  
  return max;
}')

cppFunction('NumericVector diff_calc(NumericVector x, int y = 1) {
	int n = x.size();
	NumericVector out(n-y);
	
	for(int i = (0+y); i < n; ++i) {
		out[i-y] = x[i] - x[i-y];
	}

	return out;
	
}')
