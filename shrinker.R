#' @title Weighted shrinkage estimation
#' @description Shrink values towards the mean (in the sample or the overall cohort) to an inverse degree to the confidence you assign to that observation.
#' @param x Numeric vector of values to be shrunken towards the mean.
#' @param n Numeric vector with corresponding entries to x, specifying the number of observations used to calculate x, or some other confidence weight to associate with x.
#' @param m Number specifying weight of the shrinkage estimation, relative to the number of observations in the input vector n. Defaults to the minimum of n, but this is an arbitrary value and should be explored to find an optimal value for your use case.
#' @param meanVal Number specifying the overall mean towards which the values should be shrunken. Defaults to NULL, in which case it is calculated as the (non-weighted) arithmetic mean of the values in the inputted vector x.
#' @return A numeric vector with shrunken data values.
#' @references http://math.stackexchange.com/a/41513
shrinker <- function(x, n, m = NULL, meanVal = NULL){
  if(is.null(m)) m = min(n)
  if(is.null(meanVal)) meanVal = mean(x)
  shrunk_vals = (n / (n + m)) * x + (m / (n + m)) * meanVal
  return(shrunk_vals)
}

test_x = runif(100, 0, 10)
test_n = floor(runif(100, 30, 1000))
res = shrinker(test_x, test_n)
