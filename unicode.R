
#unicode symbols 
#http://www.r-bloggers.com/unicode-symbols-in-r/
TestUnicode <- function(start="25a0", end="25ff", ...)
  {
    nstart <- as.hexmode(start)
    nend <- as.hexmode(end)
    r <- nstart:nend
    s <- ceiling(sqrt(length(r)))
    par(pty="s")
    plot(c(-1,(s)), c(-1,(s)), type="n", xlab="", ylab="",
         xaxs="i", yaxs="i")
    grid(s+1, s+1, lty=1)
    for(i in seq(r)) {
      try(points(i%%s, i%/%s, pch=-1*r[i],...))
    }
  }