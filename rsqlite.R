#learning a bit of a tutorial from http://blog.rstudio.org/2014/10/25/rsqlite-1-0-0/
#want to find some practice gnxp/ad data in a sql database...

library(DBI)

con <- dbConnect(RSQLite::SQLite(), ":memory:")

dbWriteTable(con, "mtcars", mtcars, row.names = FALSE)

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4 AND mpg < 23")

str(res)

dbDisconnect(con)