library(bayesbio)

convert_rds_to_tsv <- function(data_set, verbose = TRUE){
  df = readRDS(paste0("/Users/mckena01/Dropbox/zhang/brain_gnxp/cell_means_sync/",
    data_set, "_gene.rds"))
  if(verbose) print(colnames(df))
  df_mean_only = df[ , !grepl("_se",colnames(df))]
  df_mean_only = df_mean_only[ , !grepl("_log",colnames(df_mean_only))]
  if(verbose) print(colnames(df_mean_only))
  df_mean_only = cbind(Gene = rownames(df_mean_only), df_mean_only)
  rownames(df_mean_only) = NULL
  write.table(df_mean_only,
    file=paste0("/Users/mckena01/Dropbox/zhang/brain_gnxp/cell_means_sync/", data_set, "_gene_level.tsv"),
    quote=FALSE, sep='\t', col.names = TRUE, row.names = FALSE)

}

convert_rds_to_tsv("darmanis")
convert_rds_to_tsv("tasic")
convert_rds_to_tsv("z14")
convert_rds_to_tsv("z15")
convert_rds_to_tsv("zeisel")
