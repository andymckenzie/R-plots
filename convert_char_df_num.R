char_df = read.table("char_df.txt", col.names = TRUE)

char_df_char = apply(char_df, 2, as.character)

############################


a <- data.frame(x=rnorm(1:100, 10, 1), y=1:100)
b <- data.frame(x=rnorm(1:100, 500, 50), y=1:100)

# Merging data frames to a list, which we aim to loop through
data_frame_list <- list(a, b)

# Desired list
new_list <- list()

# The loop
# I want two simple values from each data frame (value1 and value2)
numbers_to_extract = 5
for(i in 1:length(data_frame_list)) {
   for(j in 1:numbers_to_extract) {
      value1 = data_frame_list[[i]][j,1]
      value2 = data_frame_list[[i]][j,2]
      new_list[[numbers_to_extract*(i-1)+j]] = c(value1, value2)
   }
}
