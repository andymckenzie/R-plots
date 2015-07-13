#cell code estimates cell type markers
#then finds the 
#but this data set example only uses pure cell type expression data..  

library(CellCODE)
library(RColorBrewer)

data("GSE29619")
data("GSE29619facts")
data("IRIS")

#Finds cell type markers for a matrix of pure cell type expression data
#data: Pure cell expression data. Each column represents a unique
#         cell type.
# cutoff: In order to be considered a marker gene the gene's expression
#         in a single cell type must exceed all other cell types by
#         this amount.
irisTag = tagData(IRIS[,c("Neutrophil-Resting","CD4Tcell-N0", 
	"Monocyte-Day0", "Bcell-naïve", "NKcell-control", "PlasmaCell-FromPBMC", 
	"DendriticCell-LPSstimulated")], 2, max=20, ref=GSE29619, ref.mean=F)
	
colnames(irisTag) = c("Neutrophil","Tcell", "Monocyte", "Bcell", "NKcell", 
	"PlasmaCell", "DendriticCell")

#getAllSPVs(data, grp, dataTag, method = c("mixed", "raw", "residual", "SVA"), plot = F, mix.par = 0.3)
#Estimates surrogate proportion variables  from data and cell type markers.
#A sample by cell-type matrix of surrogate proportion variables for each marker
SPVs = getAllSPVs(GSE29619, paste(GSE29619.facts[,"vaccine"], 
	GSE29619.facts[,"time"]), irisTag, "mixed", T)
	
data("fcm")

ii7v = which(GSE29619.facts[,3]=="D7")

plot(fcm[ii7v,3], SPVs[ii7v,6], log="x", ylab="Plasma Cell SPV", 
	xlab="Plasmablast fraction (in percent)", pch=19)

#A simple function to comupte residuals of a regression
     # dat: A matrix of data.
     # lab: Either a factor or a model matrix.
SPVsR = t(resid(t(SPVs), model.matrix(~0+as.factor(GSE29619.facts[,2]))))

par(mfrow=c(2,3), mai=c(1,0.4,0.4,0.1), omi=rep(0,4))

for (i in c(2:7)){
	
	boxplot(SPVsR[,i] ~ as.factor(paste(GSE29619.facts[,4],
		GSE29619.facts[,3])), outline=F, density=c(10,20,300),  
		las=2, yaxt="n", col=c(brewer.pal(3,"Blues"), 
		brewer.pal(3, "Oranges")), density=c(10,20,300), at=c(1,2,3,5,6,7)) 
	title(colnames(irisTag)[i])

}
