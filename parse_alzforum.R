library(XML)

#may want to use this instead 
library(rclinicaltrials)

stopped_url = "http://www.alzforum.org/therapeutics/search?fda_statuses%5B%5D=184&fda_statuses%5B%5D=190&fda_statuses%5B%5D=189&fda_statuses%5B%5D=33161&target_types=&therapy_types=&conditions%5B%5D=145&keywords-entry=&keywords="

stopped_table = readHTMLTable(stopped_url)[[1]] 
colnames(stopped_table) = make.names(colnames(stopped_table))

#some of the diseases have FDA statuses for these same drugs for other indications; these should be converted to the AD-relevant status 
FDA_status_split = strsplit(stopped_table$FDA.Status, ",", fixed = TRUE)
conditions = strsplit(stopped_table$Condition, ",", fixed = TRUE)
AD_indices = sapply(conditions, function(x) grep("Alzheimer's Disease", x))
stopped_table$FDA.Status_AD = stopped_table$FDA.Status

for(i in 1:length(stopped_table$FDA.Status_AD)){
	
	tmp = FDA_status_split[[i]][AD_indices[i]]
	tmp = gsub(" ", "", tmp)
	stopped_table$FDA.Status_AD[i] = tmp
	
}


all_url = "http://www.alzforum.org/therapeutics/search?fda_statuses=&target_types=&therapy_types=&conditions%5B%5D=145&keywords-entry=&keywords="

all_table = readHTMLTable(all_url)[[1]]
colnames(all_table) = make.names(colnames(all_table))

FDA_status_split = strsplit(all_table$FDA.Status, ",", fixed = TRUE)
conditions = strsplit(all_table$Condition, ",", fixed = TRUE)
AD_indices = sapply(conditions, function(x) grep("Alzheimer's Disease", x))
all_table$FDA.Status_AD = all_table$FDA.Status

for(i in 1:length(all_table$FDA.Status_AD)){
	
	tmp = FDA_status_split[[i]][AD_indices[i]]
	tmp = gsub(" ", "", tmp)
	all_table$FDA.Status_AD[i] = tmp
	
}

#not 100% up-to-date; e.g., lists biogen's drug as in phase I, when in reality it is in phase III 