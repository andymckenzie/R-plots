#!/bin/bash

#In this exercise, you will need to write a function called ENGLISH_CALC which can process sentences such as:

#'3 plus 5', '5 minus 1' or '4 times 6' and print the results as: '3 + 5 = 8', '5 - 1 = 4' or '4 * 6 = 24' respectively.

english_calc() {
	if [ "$2" == "plus" ]
	then 
		result=$(($1 + $3))
		echo $result
	fi
	if [ "$2" == "minus" ]
	then 
		result=$(($1 - $3))
		echo $result
	fi
	if [ "$2" == "times" ]
	then 
		result=$(($1 * $3))
		echo $result	
	fi	
} 

english_calc 3 plus 4
english_calc 6 minus 1
english_calc 8 times 2
 