
#downloading variants from Ingenuity results 
variants = read.table("/Users/amckenz/Downloads/PredictedDeleterious-4_atm.txt", fill = TRUE, sep = "\t", header = TRUE)

#load the brain cell gene expression data 
#data from http://www.jneurosci.org/content/34/36/11929.full
library(readxl)
barres = read_excel("/Users/amckenz/Dropbox/zhang/general_data/zhang_2014_mouse_celltype/barreslab_rnaseq_2014_fpkm_oneper.xlsx")

barres$Gene.symbol = toupper(barres$`Gene symbol`)

variants_braingnxp = merge(variants, barres, by.x = "Gene.Symbol", 
	by.y = "Gene.symbol")

variants_braingnxp$BP = variants_braingnxp$Position
variants_braingnxp$CHR = as.numeric(variants_braingnxp$Chromosome)
variants_braingnxp$P = log(variants_braingnxp$Neuron, 10)
variants_braingnxp$SNP = variants_braingnxp$Gene.Symbol

variants_manhattan = variants_braingnxp[ , c("BP", "CHR", "P", "SNP")]
variants_manhattan = variants_manhattan[complete.cases(variants_manhattan), ]

#see here for usage http://www.gettinggeneticsdone.com/2014/05/qqman-r-package-for-qq-and-manhattan-plots-for-gwas-results.html
library(qqman)

#totally arbitrarily putting the 
manhattan(variants_manhattan, logp = FALSE, ylim = c(0, 120), 
	suggestiveline = 10, genomewideline = 20, ylab = "Neuronal Gene Expression", 
	highlight = "SYN2")

#evaluate the top hit more specifically 
variants_braingnxp[variants_braingnxp$Gene.Symbol == "SYN2", ]

