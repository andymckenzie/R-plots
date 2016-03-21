
foo <- function(arg1, arg2, arg3 = "sum"){
  if(arg3 == "sum"){
    result <- arg1 + arg2
  }
  if(arg3 == "multiply"){
    result <- arg1 * arg2
  }
  return(result)
}
