#exercise 6.3 in DBDA 

library(rjags)

#########
# instantiate data 
# 0 = F, 1 = J
radio = c(rep(0, 40), rep(1, 10))
ocean_mountain = c(rep(0, 15), rep(1, 35))

#############
# prep data for JAGS 

dataList = list(
  y = ocean_mountain ,
  Ntotal = length(ocean_mountain) 
)

############
# instantiate a bernoulli model that can accomodate both data sets 

model_string = "
  model {
    for ( i in 1:Ntotal ) {
      y[i] ~ dbern(theta)
    }
    #nb that the beta prior can have an effect http://stats.stackexchange.com/q/70661/2073
    theta ~ dbeta( 1, 1) 
  }" 
  
parameters = c( "theta")     # The parameters to be monitored
adaptSteps = 500             # Number of steps to adapt the samplers
burnInSteps = 500            # Number of steps to burn-in the chains
nChains = 4                  # nChains should be 2 or more for diagnostics 
thinSteps = 1 
nIter = 1000 
  
jagsModel = jags.model( textConnection(model_string) , 
  data=dataList ,  
  n.chains=nChains , n.adapt=adaptSteps )

codaSamples = coda.samples( jagsModel , 
  variable.names=parameters , 
  n.iter=nIter , thin=thinSteps )
  #
#
plotMCMC = function( codaSamples , data , compVal=0.5 , rope=NULL ,
                     compValDiff=0.0 , ropeDiff=NULL ,
                     saveName=NULL , saveType="jpg" ) {
  #-----------------------------------------------------------------------------
  # N.B.: This function expects the data to be a data frame,
  # with one component named y being a vector of integer 0,1 values,
  # and one component named s being a factor of subject identifiers.
  y = data$y
  s = as.numeric(data$s) # converts character to consecutive integer levels
  # Now plot the posterior:
  mcmcMat = as.matrix(codaSamples,chains=TRUE)
  chainLength = NROW( mcmcMat )
  Ntheta = length(grep("theta",colnames(mcmcMat)))
  openGraph(width=2.5*Ntheta,height=2.0*Ntheta)
  par( mfrow=c(Ntheta,Ntheta) )
  for ( t1Idx in 1:(Ntheta) ) {
    for ( t2Idx in (1):Ntheta ) {
      parName1 = paste0("theta[",t1Idx,"]")
      parName2 = paste0("theta[",t2Idx,"]")
      if ( t1Idx > t2Idx) {
        # plot.new() # empty plot, advance to next
        par( mar=c(3.5,3.5,1,1) , mgp=c(2.0,0.7,0) )
        nToPlot = 700
        ptIdx = round(seq(1,chainLength,length=nToPlot))
        plot ( mcmcMat[ptIdx,parName2] , mcmcMat[ptIdx,parName1] , cex.lab=1.75 ,
               xlab=parName2 , ylab=parName1 , col="skyblue" )
      } else if ( t1Idx == t2Idx ) {
        par( mar=c(3.5,1,1,1) , mgp=c(2.0,0.7,0) )
        postInfo = plotPost( mcmcMat[,parName1] , cex.lab = 1.75 ,
                             compVal=compVal , ROPE=rope , cex.main=1.5 ,
                             xlab=parName1 , main="" )
        includeRows = ( s == t1Idx ) # identify rows of this subject in data
        dataPropor = sum(y[includeRows])/sum(includeRows)
        points( dataPropor , 0 , pch="+" , col="red" , cex=3 )
      } else if ( t1Idx < t2Idx ) {
        par( mar=c(3.5,1,1,1) , mgp=c(2.0,0.7,0) )
        postInfo = plotPost(mcmcMat[,parName1]-mcmcMat[,parName2] , cex.lab = 1.75 ,
                           compVal=compValDiff , ROPE=ropeDiff , cex.main=1.5 ,
                           xlab=paste0(parName1,"-",parName2) , main="" )
        includeRows1 = ( s == t1Idx ) # identify rows of this subject in data
        dataPropor1 = sum(y[includeRows1])/sum(includeRows1)
        includeRows2 = ( s == t2Idx ) # identify rows of this subject in data
        dataPropor2 = sum(y[includeRows2])/sum(includeRows2)
        points( dataPropor1-dataPropor2 , 0 , pch="+" , col="red" , cex=3 )
      }
    }
  }
}

#
