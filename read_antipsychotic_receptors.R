library(bayesbio)
library(corrplot)
library(cluster)

setwd("/Users/mckena01/Github/R-plots/")

#https://en.wikipedia.org/wiki/Antipsychotic#Comparison_of_medications
rec = read.delim("antipsychotic_receptors.tsv")
rownames(rec) = rec$`Drug.name`
rec = rec[ , !colnames(rec) %in% c("Drug.name")] 
colnames(rec) = gsub("X5", "5", colnames(rec))
colnames(rec) = gsub("5.H", "5-H", colnames(rec))
colnames(rec) = gsub("HT2A.D2", "HT2A/D2", colnames(rec))
rec[rec == "?"] = NA
rec[rec == ">10000"] = 10000
rec[rec == ">10000 "] = 10000
rec[rec == ">5000"] = 5000
rec[rec == ">100000"] = 100000
rec[rec == ">1000"] = 1000
rec[rec == "ND"] = NA
rec = as.matrix(rec)
class(rec) = "numeric"

rec = rec[apply(rec, 1, function(x){sum(is.na(x)) < 4}), ]
rec = 1/(rec^(1/10)) #arbitrary for visualization
corrplot(rec, method = c("circle"), is.corr = FALSE, tl.pos = "lt",
  addgrid.col = "black", cl.pos = "n")

rec_daisy = daisy(rec)
rec_fit = hclust(rec_daisy, method="ward")
plot(rec_fit)
rect.hclust(rec_fit, k=5, border="blue")
