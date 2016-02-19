info = read.table("col_fill.txt", sep = "|", header = TRUE)
info$A_DO <- as.numeric(grepl("DO",info[,"ACTUAL"]))
