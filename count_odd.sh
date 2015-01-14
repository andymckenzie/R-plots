#!/bin/bash

#In this exercise, you will need to loop through and print out all even numbers from the numbers list in the same order they are received. Don't print any numbers that come after 237 in the sequence.

COUNT=0
while [ $COUNT -lt 237 ]; do
  COUNT=$((COUNT+1))
  # Check if COUNT is odd
  if [ $(($COUNT % 2)) = 1 ] ; then
    continue
  fi
  echo $COUNT
done