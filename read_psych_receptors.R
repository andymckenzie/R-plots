library(bayesbio)
library(corrplot)
library(cluster)

setwd("/Users/mckena01/Github/R-plots/")

#https://en.wikipedia.org/wiki/Pharmacology_of_antidepressants#Receptor_affinity
rec = read.delim("psych_receptors.tsv")
rownames(rec) = rec$Compound
rec = rec[ , !colnames(rec) %in% c("Compound", "MT1A", "MT1B")]
colnames(rec) = gsub("X5", "5", colnames(rec))
colnames(rec) = gsub("5.H", "5-H", colnames(rec))
rec[rec == "?"] = NA
rec[rec == ">10000"] = 10000
rec[rec == ">35000"] = 35000
rec[rec == ">100000"] = 100000
rec[rec == ">1000"] = 1000
rec[rec == "15 (Agonist)"] = NA
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
