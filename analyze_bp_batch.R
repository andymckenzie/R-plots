bp_batch = read.csv("/Users/amckenz/Dropbox/random_research/cryonics_survey/Batch_1917857_batch_results.csv", 
	header = TRUE)
	
#create list of all unique reasons (i.e., main and ancillary) that each participant gave for no BP 
all_reasons = mapply(c, as.list(bp_batch$Answer.MainReasonNoBP), strsplit(bp_batch$Answer.ReasonsNoBP, "|", fixed = T))
all_reasons_unique = mapply(unique, all_reasons) 