#' @title Write df with delimiter style.
#' @description A wrapper function for write.table that has the same options as read.delim.
#' @param df Data frame to be written.
#' @param file Full or relative path to file to be written.
#' @param row.names Logical indicating whether to include row names.
#' @param col.names Logical indicating whether to include column names.
#' @param quote Logical indicating whether to put quotes around the resulting values.
#' @param sep Deliter to separate fields in the resulting file. Default is tab separation.
#' @param ... Additional arguments to write.table.
#' @return None; side-effect is to write to a file.
#' @export
write.delim <- function(df, file, row.names = FALSE, col.names = TRUE,
  sep = "\t", quote = FALSE, ...){
  write.table(df, file, row.names = row.names, col.names = col.names, sep = sep,
    quote = quote, ...)
}
