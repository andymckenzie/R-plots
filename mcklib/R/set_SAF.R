#' This function sets stringsAsFactors (SAF) as desired within a function. 
#' @param status Logical value indicating whether you want stringsAsFactors to be set to TRUE or FALSE within the function, be the default is returned to at the end of the function. Default = FALSE. 
#' @export 
set_SAF <- function(status = FALSE){
	
	SAF = getOption("stringsAsFactors")
	on.exit(options(stringsAsFactors = SAF))
	options(stringsAsFactors = FALSE)
	
}
