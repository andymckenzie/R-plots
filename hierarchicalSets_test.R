#just checking out the tutorial; seems useful for creating hierarchies from situations with shared discrete data between data sets 

library(hierarchicalSets)
data('twitter')
twitSet <- create_hierarchy(twitter)
#don't really understand the data type here, but from the docs, it makes sense ... 
#The sets to analyse. Can either be a matrix/data.frame giving the presence/absence pattern of elements, with elements as rows and sets as columns, or a list of vectors giving the elements of the individual sets.

plot(twitSet, type = 'intersectStack', showHierarchy = TRUE)
#definitely a pretty visualization, and seems very intuitive 
