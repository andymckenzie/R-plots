library(readxl)
library(GEOquery)
library(bayesbio)
library(ggplot2)
library(rtracklayer)
library(DGCA)
library(gridExtra) #grid.arrange

gnxp = read_excel("/Users/amckenz/Dropbox/furzeri/GSE52462_Nfurzeri_MZM_brain_Normal_Ageing_counts_RPKM.xls")
gnxp = as.data.frame(gnxp)
rownames(gnxp) = make.unique(gnxp$danrer_ensembl_gene_id)
gnxp = gnxp[ , -c(1, 2, 3)]

matrix = getGEO(filename = "/Users/amckenz/Dropbox/furzeri/GSE52462_series_matrix.txt", getGPL = FALSE)
meta = matrix@phenoData@data
meta$week_ages = meta$`characteristics_ch1`
meta$week_ages = gsub("age: ", "", meta$week_ages)
meta$week_ages = gsub(" weeks", "", meta$week_ages)

#match the sample names
if(!identical(colnames(gnxp), meta$title)) stop("Pheno table doesn't match sample names.")

#get ens symbols for cnp and ugt8a
gtf = readGFF("/Users/amckenz/Dropbox/furzeri/Danio_rerio.GRCz10.88.gtf", version=2L)
#gtf[gtf$gene_name == "cnp" &!is.na(gtf$gene_name), ]
#ENSDARG00000070822 is the longest/full transcript for cnp
# gtf[gtf$gene_name == "ugt8" &!is.na(gtf$gene_name) & gtf$type == "gene", "gene_id"]
# [1] "ENSDARG00000037455"

gnxp_cnp = gnxp[rownames(gnxp) == "ENSDARG00000070822", ]
rownames(gnxp_cnp) = "cnp"
gnxp_ugt8 = gnxp[rownames(gnxp) == "ENSDARG00000037455", ]
rownames(gnxp_ugt8) = "ugt8"

design = makeDesign(meta$week_ages)

cnp_age = plotVals(gnxp_cnp, design, compare = c("5", "12", "20", "27", "39"),
  gene = "cnp", dotplot_size = 4) + theme(legend.position="none") + ylab("cnp RPKM")
ugt8_age = plotVals(gnxp_ugt8, design, compare = c("5", "12", "20", "27", "39"),
  gene = "ugt8", dotplot_size = 4) + theme(legend.position="none") + xlab("Weeks") + ylab("ugt8 RPKM")

grid.arrange(cnp_age, ugt8_age, ncol = 1)
