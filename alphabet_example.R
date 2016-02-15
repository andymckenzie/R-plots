#take a string of the letters of the alphabet (1-26) and add the number 1 after all of the letters

alphabet <- letters[1:26]
total <- ""
for(i in alphabet){
  newthing <- paste(i, 1, sep = "")
  total <- c(total, newthing)
}
total
