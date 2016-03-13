#trying to answer http://stackoverflow.com/questions/35928718/name-matching-with-different-length-data-frames-in-r

#this doesn't do what i thought it did
a = letters[1:5]
b = c(letters[1:9], letters[11])
a = letters[1:10]
adist(a, b)
