
#unfortunately this is not the type of data set that we want, but it was a fun idea 
seveight =  read.table("/Users/amckenz/Documents/github/R-plots/nba/playerstats20072008reg20081211.txt", 
	fill = T, sep = '\t', quote = "", header = T)
cols_to_remove = c("SimplePossFor", "SimplePossOpp", "SimpleMin", 
	"SimpleORebFor", "SimpleORebOpp", "SimpleDRebFor", 
	"SimpleDRebOpp", "AdjustedPMStdErr", "SimplePointsOpp", 
	"SimpleORebRate", )
seveight = seveight[ , -which(names(seveight) %in% cols_to_remove)]
off_court_vars = grep("OffCourt", names(seveight))	
seveight = seveight[ , -off_court_vars]
seveight[seveight == "NULL"] = NA 

seveig_mat = as.matrix(seveight[ , -c(1:3)])
matr = matrix(0, nrow = nrow(seveig_mat), ncol = ncol(seveig_mat))
for(i in 1:ncol(seveig_mat)){
	matr[ , i] = as.numeric(seveig_mat[ , i])
}

rownames(matr) = seveight$PlayerTrueName
colnames(matr) = colnames(seveight[ , -c(1:3)])

matr = scale(matr) 

pair_matr = cor(t(matr), use="pairwise.complete.obs")

hr = hclust(as.dist(1-pair_matr), method="complete")
mycl <- cutree(hr, h=max(hr$height/1.5))
mycl[hr$order] 

#https://www.biostars.org/p/86563/
#cluster1 <- pair_matr[mycl == 2,]