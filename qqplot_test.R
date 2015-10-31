
#following the vignette here 
#https://cran.r-project.org/web/packages/qqman/vignettes/qqman.html

library(qqman)

manhattan(gwasResults)

manhattan(gwasResults, main = "Manhattan Plot", ylim = c(0, 10), cex = 0.6, 
    cex.axis = 0.9, col = c("blue4", "orange3"), suggestiveline = F, genomewideline = F, 
    chrlabs = c(1:20, "P", "Q"))
	
#Run str(gwasResults). Notice that the gwasResults data.frame has SNP, chromosome, position, and p-value columns named SNP, CHR, BP, and P. If you're creating a manhattan plot and your column names are different, you'll have to pass the column names to the chr=, bp=, p=, and snp= arguments. See help(manhattan) for details.

#this is an awesome way of making manhattan plots or plotting any other single number associated with genomic positions (i.e. CHR + BP) vs genome-wide numbers 