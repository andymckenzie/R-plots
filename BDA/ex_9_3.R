library(rjags)
library(reshape2)

setwd("/Users/amckenz/Documents/github/R-plots/BDA")

#load ff data 
data = read.csv("/Users/amckenz/Documents/github/FantasyFootball/FFStats.csv")
data$ID = 1:length(data$Owner)
datam = data[ , c("ID", paste0("W", 1:12, "F"))]
dataa = melt(datam, id = "ID", value.name = "Points")

# N.B.: This function expects the data to be a data frame, 
# with one component named y being a vector of integer 0,1 values,
# and one component named s being a factor of subject identifiers.


#script from DBDA 
source("/Users/amckenz/Desktop/DBDA2Eprograms/Jags-Ydich-XnomSsubj-MbinomBetaOmegaKappa.R")
genMCMC = function( data , sName="s" , yName="y" ,  
                    numSavedSteps=50000 , saveName=NULL , thinSteps=1 ,
                    runjagsMethod=runjagsMethodDefault , 
                    nChains=nChainsDefault ) { 
