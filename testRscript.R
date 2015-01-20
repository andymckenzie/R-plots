## myScript.R
args <- commandArgs(trailingOnly = TRUE)
rnorm(n=as.numeric(args[1]), mean=as.numeric(args[2]))


#call > Rscript myScript.R 5 100
