#!/bin/bash
elves=10
while [  $elves -gt 0 ]; do
    echo There are $elves elves!
    let elves=elves-1
done

echo There are no more elves, sadface. 
