#want to learn how the quartz graphics device works 

#following some from general graphics devices in R, https://cran.r-project.org/doc/manuals/r-release/R-ints.html, and some from ?quartz 

#xquartz is the osx implementation of x11

#‘par’ can be used to set or query graphical parameters.

# Each device has its own set of graphical parameters.  If the
     # current device is the null device, ‘par’ will open a new device
     # before querying/setting parameters.  (What device is controlled by
     # ‘options("device")’.)
		 
#this changes the height/width of new quartz plots 
quartz.options(height = 6, width = 6) 
 
set.seed(42)

a = runif(20, 0, 1) 
b = runif(20, 0, 1) 

plot(a, b)

quartz.options(height = 4,  width = 4, pointsize = 10)

#quartz.options() only changes the actual size if you close the current device
plot(a, b)

dev.off()

plot(a, b)

#i can still see these.. R is designed to display points down to one pixel in size
#kind of unclear what the mapping is between pointsize and pixel size.. r internals says that it depends on the device, while quartz... 
quartz.options(height = 4,  width = 4, pointsize = 0.1)

dev.off()

plot(a, b)












#Font sizes are in big points.
#should be able to figure out what is going on w font sizes based on the "big point" convention to understand the mapping

#what i want to get is the mapping, for quartz, between pointsize and pixel radius, and between font size and pixels


#for creating figures for papers, bset practice is to start with a call to the device driver, e.g. w pdf or png or tiff, run the graphics commands, and then finish by calling dev.off()
#pdf() is a good format bc it is vector-based so it's good across platforms 

#by default R assumes 72 pxiels per inch; this canb e changed via the res() argument 