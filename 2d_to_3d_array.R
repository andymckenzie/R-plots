
#http://stackoverflow.com/questions/37662433/r-3d-array-to-2d-matrix

my_array <- array(1:600, dim=c(10,5,12))
my_array_copy = my_array
dim(my_array_copy) <- c(10 * 5 , 12)

my_matrix<-data.frame()
for (j in 1:5) {
  for (i in 1:10) {
     my_matrix <- rbind (my_matrix, my_array[i,j,1:12])
 }
}
