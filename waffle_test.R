library(waffle)
#this is what a success rate of 99.6% refers to 
#source: http://alzres.com/content/6/4/37
alzheimers_trials = c('Failures' = 249, 
	'Successes' = 1)
waffle(alzheimers_trials, rows=12, size=1, 
       title="Trials for Alzheimer's Disease, 2002 - 2012")
	  
