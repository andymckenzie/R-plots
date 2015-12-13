#' This function returns all duplicated entries and messages the total number. 
#' @param x A vector (character or numeric are supported) whose duplicate members should be identified and reported. 
#' @param verbose A logical vector indicating whether the total number of duplicates found should be messaged to the user as a convenience of using str() afterwards. Default = TRUE. 
#' @return By default, a logical vector corresponding to 
#' @examples 
#' get_dups(c(letters[1:6], letters[2:4]))
#' @references http://stackoverflow.com/questions/33252365
#' @export 
get_dups <- function(x, verbose = TRUE){
	
	x = (duplicated(x)|duplicated(x, fromLast=TRUE))
	
	if(verbose){
		message(paste0("There are ", sum(x), " duplicated elements out of ", 
			length(x), " total elements."))
	}
	
	return(x)
	

}
