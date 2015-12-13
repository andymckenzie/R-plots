#' This function creates random and unique character strings. 
#' @param number Specifies the number of character strings that should be created. 
#' @param length Specifies the length of each character string in letters.
#' @param upper Binary parameter specifying whether the character strings should be uppercase. Default = FALSE, so the character strings are all lowercase. 
#' @return A vector of random character string of the lengths as specified. 
#' @references http://stackoverflow.com/a/1439541/560791
#' @export 
create_strings <- function(number, length, upper = FALSE){
	strings = replicate(number, 
		paste(sample(letters, length, replace = TRUE), 
		collapse = "")
	if(upper) toupper(strings)
	return(strings)
}
