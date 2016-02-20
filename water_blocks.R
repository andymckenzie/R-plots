#http://stackoverflow.com/questions/24414700/amazon-water-collected-between-towers
#alright pretty naive/brute force solution but whatever it works

#You are given an input array whose each element represents the height of a line towers.
#The width of every tower is 1. It starts raining. How much water is collected between the towers?

input1 = c(1,5,3,7,2)
input2 = c(5,3,7,2,6,4,5,9,1,2)

input = input2

#find ones that are higher than the previous one
higher_than_previous = rep(FALSE, length(input2))
peaks = rep(FALSE, length(input2))

higher_than_previous[1] = TRUE
peaks[1] = TRUE
for(i in 1:length(input)){
  if(i == 1){
    next
  }
  if(input[i]>input[i-1]){
    higher_than_previous[i] = TRUE
    peaks[i] = TRUE
  }
  if(higher_than_previous[i] == TRUE & higher_than_previous[i-1] == TRUE){
    peaks[i-1] = FALSE
  }
}

#for each peak pair, find which one is higher
peaks_indices = which(peaks)
peak_heights = input[peaks_indices]
peak_pairs_heights_first = peak_heights[-length(peak_heights)]
peak_pairs_heights_second = peak_heights[-1]
peak_pairs_higher = peak_pairs_heights_first > peak_pairs_heights_second
peak_pairs_lower_height = ifelse(peak_pairs_higher, peak_pairs_heights_second, peak_pairs_heights_first)

#for the space within each of the peak pairs,
total_water = 0
peak_pair_water = numeric(length(peak_pairs_lower_height))
for(i in 1:length(peak_pairs_lower_height)){
  #identify the indices of the peak to loop over
  for(j in (peaks_indices[i]+1):(peaks_indices[i+1]-1)){
    print('new iteration')
    print(input[j])
    print(peak_pairs_lower_height[i])
    peak_pair_water[i] = peak_pair_water[i] + (peak_pairs_lower_height[i] - input[j])
  }
  total_water = total_water + peak_pair_water[i]
}
print(peak_pair_water)
print(total_water)
