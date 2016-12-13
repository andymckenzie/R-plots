
test_data = data.frame(name = letters[1:5000], type = floor(runif(5000, 1, 5)))
start.time <- Sys.time()
heat = matrix(NA, nrow = nrow(test_data), ncol = nrow(test_data))
rownames(heat) = colnames(heat) =
for(i in 1:nrow(test_data)){
  row_tmp = test_data$type == test_data$type[i]
  heat[row_tmp, i] = test_data$type[row_tmp]
}
diag(heat) = NA
end.time <- Sys.time()
time.taken <- end.time - start.time
