#some recommended by hadley's devtools
#some from http://gettinggeneticsdone.blogspot.com.es/2013/07/customize-rprofile.html

## .First() runs at the start of every R session. 
.First <- function() {
  options(
    repos = c(CRAN = "http://cran.rstudio.com/"),
    browserNLdisabled = TRUE,
    deparse.max.lines = 2)
  library(ggplot2)
  cat("\nSuccessfully loaded .Rprofile at", date(), "\n")
}

if (interactive()) {
  suppressMessages(require(devtools))
}

## Load packages
library(BiocInstaller)

## Don't show those silly significance stars
options(show.signif.stars=FALSE)

## Do you want to automatically convert strings to factor variables in a data.frame?
## WARNING!!! This makes your code less portable/reproducible.
options(stringsAsFactors=FALSE)

## Don't ask me for my CRAN mirror every time
options("repos" = c(CRAN = "http://cran.rstudio.com/"))

## Create a new invisible environment for all the functions to go in so it doesn't clutter your workspace.
.env <- new.env()

## Returns a logical vector TRUE for elements of X not in Y
.env$"%nin%" <- function(x, y) !(x %in% y) 

## Attach all the variables above
attach(.env)

