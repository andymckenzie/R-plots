
library(cluster)
library(fpc)
impute = FALSE
cluster_1 = FALSE
cluster_2 = TRUE

alltime = read.table("/Users/amckenz/Documents/github/R-plots/nba/nba_all_time_data.txt", 
	header = T, skip = 2, sep = '\t', na.strings = "-", quote = "")
alltime$GP = as.numeric(gsub(",", "", alltime$GP))
cols_to_remove = c("GP", "MIN", "FGM", "X3PM", "FTM", "eFG.", "TS.", "Player")
alltime_df = alltime[ , -which(cols_to_remove %in% colnames(alltime))]
alltime_mat = as.matrix(alltime[ , -which(cols_to_remove %in% colnames(alltime))])
rownames(alltime_mat) = alltime$Player
num_players_include = 100 
alltime_mat = alltime_mat[c(1:num_players_include), ]
alltime_mat_all = alltime_mat[complete.cases(alltime_mat),]

#this is far from perfect, eg REB types don't come close to adding up... 
if(impute == TRUE){
	#http://www.bioconductor.org/packages/release/bioc/manuals/impute/man/impute.pdf
	#knn impute the missing data 
	library(impute)
	alltime_mat = impute.knn(alltime_mat)[[1]]
}

matr = scale(alltime_mat_all) 
pair_matr = cor(t(matr), use="pairwise.complete.obs")

if(cluster_1 == TRUE){
	hr = hclust(as.dist(1-pair_matr), method="complete")
	mycl = cutree(hr, h=max(hr$height/1.5))
	mycl[hr$order] 
}

if(cluster_2 == TRUE){
	clus = kmeans(pair_matr, centers=8)
	#plotcluster(pair_matr, clus$cluster)
	num_players_show = nrow(alltime_mat_all)
	rownames(pair_matr) = c(rownames(pair_matr)[1:num_players_show], 
		rep("", length(rownames(pair_matr)) - num_players_show))
	clusplot(pair_matr, clus$cluster, color=TRUE, shade=FALSE, 
		labels = 2, lines=0, cex = 0.5)
}