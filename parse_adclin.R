library(rclinicaltrials)

ad_dl_test = clinicaltrials_download(query = 'alzheimer', count = 40, include_results = TRUE)

#find which trials are N/A... it's usually the older ones 
ad_dl_test[[1]]$study_info[which(ad_dl_test[[1]]$study_info$phase == "N/A"), ]

#need to figure out how to parse this better ... lots of potentially great info here