
library(readxl)

setwd("/Users/amckenz/Documents/lifestats/")

ls1 = read.delim("/Users/amckenz/Documents/lifestats/ls1.xlsx")
ls1$sleep_start = sapply(strsplit(ls1$sleep_clean, "-", fixed = T), "[[", 1) 
ls1$sleep_stop = sapply(strsplit(ls1$sleep_clean, "-", fixed = T), "[[", 2)
ls1$sleep_start_time = strptime(ls1$sleep_start, format = "%H:%M")
ls1$sleep_stop_time = strptime(ls1$sleep_stop, format = "%H:%M")
ls1$sleep_amt = ls1$sleep_stop_time - ls1$sleep_start_time
ls1$sleep_amt_real = if(ls1$sleep_amt > 0, ls1$sleep_amt, )
