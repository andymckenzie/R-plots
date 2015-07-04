#following some from http://ampcamp.berkeley.edu/5/exercises/sparkr.html

library(SparkR)

sc = sparkR.init(master="local")

data = textFile(sc, "test_data.txt")

parseFields <- function(record) {
	Sys.setlocale("LC_ALL", "C") # necessary for strsplit() to work correctly
	parts = as.numeric(strsplit(record, "\t")[[1]])
	return(parts)
}

parsedRDD = lapply(data, parseFields)

parts = partitionBy(parsedRDD, numPartitions = 4L)

cors = lapply(parts, function(row) cor(row[c(1:3)], row[c(4:6)]))

# collectPartition(parts, 0L)

#visualize the caches via http://localhost:4040/stages/
#cache(parsedRDD)
#take(parsedRDD, 4)