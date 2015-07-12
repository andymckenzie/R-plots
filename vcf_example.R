
#trying to get better at VCF files ... some from http://stackoverflow.com/questions/21598212/extract-sample-data-from-vcf-files


library(VariantAnnotation)

#load example file 
vcfFile = system.file(package="VariantAnnotation", "extdata", "chr22.vcf.gz")

param = ScanVcfParam(
    info=c("LDAF", "AVGPOST"),
    geno="GT",
    samples=c("HG00097", "HG00101"),
    which=GRanges("22", IRanges(50300000, 50400000)))

vcf = readVcf(vcfFile, "hg19", param=param)

vcf22 = as.data.frame(geno(vcf)[["GT"]])

total_minor_alleles = sum(as.numeric(unlist(sapply(strsplit(vcf22$HG00097,
	"|"), "[", c(1, 3)))))