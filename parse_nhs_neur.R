neur = read.csv("/Users/amckenz/Desktop/compendium_of_neurology_data/data/comp-of-neur-data-ccg-csv_v2.csv",
  na.strings = c("no data", "*", "-"))

#all of the data sets have a similar number of patients per 1000 pop
hist(neur$NHS_Comparators_Mapped_LTNC_Admissions)

#the long tail of fibromyalgia diagnosis
hist(neur$DIDS_2, breaks = 50)
#whereas dementia diagnosis seems to be more consistent
hist(neur$DIDS_7, breaks = 50)

#officially want to associate this with lat-lon within england
hist(neur$DIDS_12, breaks = 50)

#probably would want to adjust for the total number of pt's, DIDS_163
