#data from http://www.sciencemag.org/content/350/6256/94.full
#Chromosome, hg19 position, reference and alternate alleles, and genotypes of each single neuron and bulk heart are indicated. 
#also using https://www.biostars.org/p/66494/

# #load module file

library(readxl)
library(biomaRt)

snv = read_excel("/Users/amckenz/Downloads/aab1785-Lodato-Table-S3.xlsx")

snv$reg = paste(snv$CHROM, snv$POS, snv$POS, sep = ":")

ensembl=useMart("ensembl", dataset="hsapiens_gene_ensembl")

results=getBM(attributes = c("hgnc_symbol","entrezgene", "chromosome_name", "start_position", "end_position"), 
               filters = c("chromosomal_region"), 
               values = snv$reg, 
               mart = ensembl)

number_overlap = vector()
for(i in 1:length(results$start_position)){
	
	temp_pos = c(results$start_position[i]:results$end_position[i])
	chrom = results$chromosome_name[i]
	num = sum(first_overlap %in% snv[snv$CHROM == chrom, ]$POS)
	number_overlap[i] = num
	
}

first_overlap = c(results$start_position[1]:results$end_position[1])
sum(first_overlap %in% snv[snv$CHROM == "1", ]$POS)

tom = read.table("path/to/module/file.txt",
	sep = '\t', header = TRUE)
tom_modules = tom[ , which(colnames(tom) %in% c("gene_symbol", "module"))]

names_mods = unique(tom_modules$module)

for(i in 1:length(names_mods)){
	
	length_mod = length(tom_modules[tom_modules$module == names_mods[i], "gene_symbol"])
	intersect_length = length(intersect(tom_modules[tom_modules$module == names_mods[i], "gene_symbol"], results$hgnc_symbol))
	
	print(c(names_mods[i], length_mod, intersect_length))
	
}

