file1 = read.table("file1.txt", header = TRUE, stringsAsFactors = FALSE)
file2 = read.table("file2.txt", header = FALSE, stringsAsFactors = FALSE)
file1$chr_num = as.numeric(gsub("chr", "", file1$chr))
in_range <- function(chr_num, chr_start, chr_stop){
 chr_matches = file1[file1$chr_num == as.numeric(chr_num), ]
 res = any(as.numeric(chr_start) > chr_matches$Start & as.numeric(chr_stop) < chr_matches$End)
 return(res)
}
apply(file2, 1, function(x) in_range(x[1], x[2], x[3]))
