#' Version of p.adjust that allows 
#' @param p Numeric vector of p-values to adjust. Will be coerced to numeric if necessary. 
#' @param n Number of "hypotheses" to assume tested; unlike in p.adjust, this can be < length(p). Default = length(p). 
#' @param method Type of p-value correction to be employed. See p.adjust.methods for options. 
#' @references http://stackoverflow.com/a/30110186
#' @examples 
#' Compare: 
#' pvals = seq(0, 1, by = 0.01)
#' p_adjust(p = pvals, method = "BH")
#' p_adjust(p = pvals, method = "BH", n = 50) 
#' Also handles NAs by making that p-value NA in the "adjusted" list. 
#' pvals[23] = NA
#' p_adjust(p = pvals, method = "BH", n = 50) 
#' @notes
p_adjust <- function(p, method = p.adjust.methods, n = length(p)){
  
  method <- match.arg(method)
  if (method == "fdr") method <- "BH"
  nm <- names(p)
  p <- as.numeric(p)
  p0 <- setNames(p, nm)
  #if none are NA, save time on the subsequent step... 
  if (all(nna <- !is.na(p))) nna <- TRUE
  p <- p[nna]
  lp <- length(p)
  # stopifnot(n >= lp)
  if (n <= 1) 
      return(p0)
  if (n == 2 && method == "hommel") 
      method <- "hochberg"
  p0[nna] <- switch(method, bonferroni = pmin(1, n * p), holm = {
      i <- seq_len(lp)
      o <- order(p)
      ro <- order(o)
      pmin(1, cummax((n - i + 1L) * p[o]))[ro]
  }, hommel = {
      if (n > lp) p <- c(p, rep.int(1, n - lp))
      i <- seq_len(n)
      o <- order(p)
      p <- p[o]
      ro <- order(o)
      q <- pa <- rep.int(min(n * p/i), n)
      for (j in (n - 1):2) {
          ij <- seq_len(n - j + 1)
          i2 <- (n - j + 2):n
          q1 <- min(j * p[i2]/(2:j))
          q[ij] <- pmin(j * p[ij], q1)
          q[i2] <- q[n - j + 1]
          pa <- pmax(pa, q)
      }
      pmax(pa, p)[if (lp < n) ro[1:lp] else ro]
  }, hochberg = {
      i <- lp:1L
      o <- order(p, decreasing = TRUE)
      ro <- order(o)
      pmin(1, cummin((n - i + 1L) * p[o]))[ro]
  }, BH = {
      i <- lp:1L
      o <- order(p, decreasing = TRUE)
      ro <- order(o)
      pmin(1, cummin(n/i * p[o]))[ro]
  }, BY = {
      i <- lp:1L
      o <- order(p, decreasing = TRUE)
      ro <- order(o)
      q <- sum(1L/(1L:n))
      pmin(1, cummin(q * n/i * p[o]))[ro]
  }, none = p)
  p0
  
}
  