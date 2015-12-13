#' Binds data frames or matrices of varying sizes by appending NAs to columns. 
#' @return A single data frame from 
#' @references http://r.789695.n4.nabble.com/How-to-join-matrices-of-different-row-length-from-a-list-td3177212.html
#' @references http://stackoverflow.com/questions/7962267/
#' @examples 
#' cbind_fill(diamonds[1:10, ], diamonds[1:15, ])
cbind_fill <- function(...){
  
  dfs = list(...) 
  #convert to matrices if necessary 
  dfs = lapply(dfs, as.matrix)
  #find the max number of rows 
  n = max(sapply(dfs, nrow)) 
  #for each matrix 
  do.call(cbind, lapply(dfs, function (x) 
    rbind(x, matrix(, n - nrow(x), ncol(x))))) 
  
}