#read in the data
#http://sing.stanford.edu/cs303-sp11/papers/1954-Fitts.pdf
#following http://stackoverflow.com/a/17499720/560791

library(ggplot2)

x = rnorm(50, 0, 1)
y = rnorm(50, 0, 1)
z = runif(50, 0, 1)

my.data = data.frame(x, y, z)

my.plot <- ggplot(data = my.data,
                aes(x = x,
                    y = y))

my.plot <- my.plot + geom_point(aes(colour = z))

my.plot <- my.plot + scale_colour_gradientn(colours = rainbow(5)) + theme_bw()
