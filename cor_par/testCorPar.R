
#won-min's advice: 
#gpu? 
#depends on how many nodes you wanna use (e.g., minerva you could do more)

#code from http://brainchronicle.blogspot.com/2013/02/large-correlation-in-parallel.html

R <- c(2000, 5000)

bigcorPar <- function(x, nblocks = 10, verbose = TRUE, ncore="all", ...){
  library(ff, quietly = TRUE)
  require(doMC)
	if(ncore=="all"){
		ncore = detectCores()
		registerDoMC(cores = ncore)
	} else{
		registerDoMC(cores = ncore)
	}
 
	NCOL <- ncol(x)
 
	## test if ncol(x) %% nblocks gives remainder 0
	if (NCOL %% nblocks != 0){stop("Choose different 'nblocks' so that ncol(x) %% nblocks = 0!")}
 
	## preallocate square matrix of dimension
	## ncol(x) in 'ff' single format
	corMAT <- ff(vmode = "single", dim = c(NCOL, NCOL))
 
	## split column numbers into 'nblocks' groups
	SPLIT <- split(1:NCOL, rep(1:nblocks, each = NCOL/nblocks))
 
	## create all unique combinations of blocks
	COMBS <- expand.grid(1:length(SPLIT), 1:length(SPLIT))
	COMBS <- t(apply(COMBS, 1, sort))
	COMBS <- unique(COMBS)
 
	## iterate through each block combination, calculate correlation matrix
	## between blocks and store them in the preallocated matrix on both
	## symmetric sides of the diagonal
	results <- foreach(i = 1:nrow(COMBS)) %dopar% {
		COMB <- COMBS[i, ]
		G1 <- SPLIT[[COMB[1]]]
		G2 <- SPLIT[[COMB[2]]]
		if (verbose) cat("Block", COMB[1], "with Block", COMB[2], "\n")
		flush.console()
		COR <- cor(MAT[, G1], MAT[, G2], ...)
		corMAT[G1, G2] <- COR
		corMAT[G2, G1] <- t(COR)
		COR <- NULL
	}
	 
	gc()
	return(corMAT)
}


parallel <- numeric(length=length(R))
for(i in 1:length(R)){
	split <- ifelse(R[i]<=20000, 10, 20)
	MAT <- matrix(rnorm(R[i] * 10), nrow = 10)
	parallel[i] <- system.time(res <- bigcorPar(MAT, nblocks = split, verbose=FALSE))[3]
	str(res)
}
