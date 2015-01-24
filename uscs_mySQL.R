#copied lots from http://gettinggeneticsdone.blogspot.com/2011/12/query-mysql-database-from-r-using.html
  
#Load the package
library(RMySQL)
 
# Set up a connection to your database management system.
# I'm using the public MySQL server for the UCSC genome browser (no password)
mychannel <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
 
# Function to make it easier to query 
query <- function(...) dbGetQuery(mychannel, ...)

ucsc_ids='uc007aet.1' ## IDs to convert

 
# Get the UCSC gene name, start and end sites for the first 10 genes on Chromosome 12
chr12_first = query("SELECT name, chrom, txStart, cdsStart, cdsEnd, txEnd FROM hg19.knownGene WHERE name='BACE1'")
 
