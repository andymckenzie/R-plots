library(ggplot2)
library(dplyr)

dir = "/Users/amckenz/Dropbox/random_research/telomeres/"
setwd(dir)

tel = read.table("telomeres_rode2015.txt", sep = " ", header = T)
tel$score = 1:7
tel = mutate(tel, SE = SD/sqrt(N))

lm_eqn = function(x, y, df){
    m = lm(y ~ x, df);
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
         list(a = format(coef(m)[1], digits = 2), 
              b = format(coef(m)[2], digits = 2), 
             r2 = format(summary(m)$r.squared, digits = 3)))
    as.character(as.expression(eq));                 
}

ggplot(tel,aes(x = factor(score),y = Length))+geom_point(stat = "identity") + 
	geom_smooth(aes(group = 1), method = "lm", se = TRUE) + theme_bw() + 
	geom_text(aes(x = 5, y = 4700, label = lm_eqn(tel$score, tel$Length, tel)), 
		color="black", size=5, parse = TRUE) + 
	geom_errorbar(aes(x = score, ymax = Length + SE, ymin = Length - SE)) + 
	ylab("Mean Leukocyte Telomere Length", hjust = 1) + xlab("Allele Score") + 
	scale_x_discrete(labels = c(1, 2, 3, 4, 5, 6, 7))