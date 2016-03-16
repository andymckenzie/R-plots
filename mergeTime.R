#' @title Merge data frames based on the nearest datetime differences.
#' @description Takes two data frames each with time/date columns in date-time or date format (i.e., able to be compared using the function difftime), finds the rows of df2 that minimize the absolute value of the datetime for each of the rows in df1, and merges the corresponding rows of df2 into df1 for downstream processing.
#' @param df1 Data frame containing the dates for which the differences between the other data frame's date column should be minimized for each row.
#' @param df2 Data frame containing the dates which should be compared to, as well as other values that should be merged to df1 per minimized date time.
#' @param timeCol1 Character vector specifying the date/time column in df1.
#' @param timeCol2 Character vector specifying the date/time column in df2.
#' @return A merged data frame that minimizes datetime differences.
nearestTime <- function(df1, df2, timeCol1, timeCol2){
  if(!timeCol1 %in% colnames(df1)) stop("timeCol1 must specify a column name in df1.")
  if(!timeCol2 %in% colnames(df2)) stop("timeCol2 must specify a column name in df2.")
  dfMinTime = data.frame(matrix(ncol = (ncol(df2) - 1), nrow = nrow(df1)))
  colnames(dfMinTime) = colnames(df2)[!colnames(df2) %in% timeCol2]
  ties_count = 0
  for(i in 1:nrow(df1)){
      min_row = numeric()
      min_rows = apply(df2, 1, function(x) abs(as.numeric(difftime(df1[i, timeCol1], x[timeCol2]))))
      mins = (min_rows == min(min_rows))
      dfMinTime[i, ] = df2[which.min(min_rows), !(colnames(df2) %in% timeCol2), drop = FALSE]
      if(sum(mins) > 1) { ties_count = ties_count + 1 }
  }
  dfAll = cbind(df1, dfMinTime)
  if(ties_count > 0){
    message("Warning: there were ", ties_count, " difftime ties, for which the first corresponding row of df2 was chosen for merging.")
  }
  return(dfAll)
}

#' @title Merge data frames based on the nearest datetime differences and an ID column. Also removes duplicate column names from the result.
#' @description Takes two data frames each with time/date columns in date-time or date format (i.e., able to be compared using the function difftime), finds the rows of df2 that minimize the absolute value of the datetime for each of the rows in df1, and merges the corresponding rows of df2 into df1 for downstream processing.
#' @param IDcol Must be unique by row in df1. Multiple versions are allowed (and expected at least in some rows, as that is the point of the function) in df2.
#' @param df1 Data frame containing the dates for which the differences between the other data frame's date column should be minimized for each row.
#' @param df2 Data frame containing the dates which should be compared to, as well as other values that should be merged to df1 per minimized date time.
#' @param timeCol1 Character vector specifying the date/time column in df1.
#' @param timeCol2 Character vector specifying the date/time column in df2.
#' @return A merged data frame that minimizes datetime differences.
nearestTimeandID <- function(df1, df2, timeCol1, timeCol2, IDcol){
  if(!timeCol1 %in% colnames(df1)) stop("timeCol1 must specify a column name in df1.")
  if(!timeCol2 %in% colnames(df2)) stop("timeCol2 must specify a column name in df2.")
  dfMinTime = data.frame(matrix(ncol = (ncol(df2) - 1), nrow = nrow(df1)))
  colnames(dfMinTime) = colnames(df2)[!colnames(df2) %in% timeCol2]
  ties_count = 0
  for(i in 1:nrow(df1)){
      ID = df1[i, IDcol]
      min_rows = vector()
      for(j in 1:nrow(df2)){
        if(df2[j, IDcol] == ID){
          tmp = abs(as.numeric(difftime(df1[i, timeCol1], df2[j, timeCol2])))
          min_rows = c(min_rows, tmp)
        } else { min_rows = c(min_rows, NA)}
      }
      mins = (min_rows == min(min_rows))
      dfMinTime[i, ] = df2[which.min(min_rows), !(colnames(df2) %in% timeCol2), drop = FALSE]
      if(sum(mins, na.rm = TRUE) > 1) { ties_count = ties_count + 1 }
  }
  if(ties_count > 0){
    message("Warning: there were ", ties_count, " difftime ties, for which the first corresponding row of df2 was chosen for merging.")
  }
  dfAll = cbind(df1, dfMinTime)
  dfAll = dfAll[ , !duplicated(colnames(dfAll))]
  return(dfAll)
}
