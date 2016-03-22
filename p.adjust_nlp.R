#' @title Adjust p-values where n is less than p.
#' @description This function recapitulates p.adjust but allows the number of hypothesis tests n to be less than the number of p-values p. Statistical properties of the p-value adjustments may not hold. Preliminary investigations suggest that it yields good sensical results for "bonferonni" and non-sensical results for "BH" and "hochberg", while the other methods remain untested. 
#' @param p Numeric vector of p-values.
#' @param method Correction method.
#' @param n Number of comparisons to be made.
#' @references http://stackoverflow.com/a/30110186/560791
p.adjust.nlp <- function (p, method = p.adjust.methods, n = length(p)){
    method <- match.arg(method)
  if (method == "fdr")
      method <- "BH"
  nm <- names(p)
  p <- as.numeric(p)
  p0 <- setNames(p, nm)
  if (all(nna <- !is.na(p)))
      nna <- TRUE
  p <- p[nna]
  lp <- length(p)
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
