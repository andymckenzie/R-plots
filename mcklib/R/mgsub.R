#' Generalizes gsub to a vector of pattern and replacement strings. 
#' @param pattern A character vector of pattern strings to be identified in the target character vector and replaced. Note that this occurs in the order in which they are added.   
#' @param replace A character vector of replacement strings to replace the corresponding pattern strings identified in the target character vector. 
#' @param target The target character vector in which strings will be identified and replaced. 
#' @param verbose A logical value indicating whether or not the number of items identified and replaced should be reported. 
#' @return A vector with the strings in the target vector replaced as necessary.
#' @references http://stackoverflow.com/a/15254254
#' @examples 
#' mgsub(c("b", "d"), c("bat", "dog"), c(letters[1:5], letters[1:2]))
#' @export 
mgsub <- function(pattern, replace, target, verbose = TRUE, ...) {
  if (length(pattern) != length(replace)) {
    stop("Pattern and replacement vectors do not have the same length.")
  }
  result = target
  removed = vector()
  for (i in 1:length(pattern)) {
    result = gsub(pattern[i], replace[i], result, ...)
    if(verbose){
      removed[i] = sum(grepl(pattern[i], result))
    }
  }
  if(verbose){
    output = paste0()
    message("Pattern ; Number of Times Replaced")
    for(i in 1:length(pattern)){
      message(paste(pattern[i], removed[i], sep = " ; "))
    }
  }
  return(result)
}