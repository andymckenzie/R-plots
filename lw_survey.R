library(readxl) 

a = read_excel("/Users/amckenz/Downloads/2014forpublic.xlsx")

b = a[a$Age > median(a$Age, na.rm = T), ]
median(as.numeric(b$PCryonics), na.rm = T)
c = a[a$Age < median(a$Age, na.rm = T), ]
median(as.numeric(c$PCryonics), na.rm = T)


#######################################
####### predicting cryo status ########
#######################################

cryo_status = factor(a$CryonicsStatus, levels = list(No=c("No - and do not want to sign up for cryonics"), 
	Unsure="Never thought about it / don't understand", 
	Maybe= "No - still considering it",
	Planning=c( "No - would like to sign up but haven't gotten around to it", 
		"No - would like to sign up but unavailable in my area"),
	Yes= "Yes - signed up or just finishing up paperwork"))

cryo_status_n = as.numeric(cryo_status)
cryo_status_pred = 


########################################
####### predicting cryo probability ####
########################################
