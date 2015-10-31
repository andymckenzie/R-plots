

test_function <- function(foo){
	
	SAF = getOption("stringsAsFactors")
	on.exit(options(stringsAsFactors = SAF))
	
	options(stringsAsFactors = TRUE)
	print(foo) 
	print("SAF within function")
	print(getOption("stringsAsFactors"))
	
}

stringsAsFactors = FALSE
test_function("test SAF") 
print("SAF outside of function")
print(getOption("stringsAsFactors"))