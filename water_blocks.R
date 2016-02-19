#http://stackoverflow.com/questions/24414700/amazon-water-collected-between-towers
#want to start on this, but haven't made much headway
#trying to avoid a brute force (for loops) but idk why really

input = c(1,5,3,7,2)
input2 = c(5,3,7,2,6,4,5,9,1,2)

get_water_length <- function(tow){

  #get the
  block_pillars_indx = which((tow > tow[-1])[1:(length(tow)-1)])
  block_pillar_heights = tow[block_pillars_indx]

  #for each block pillar pair, find which one is higher
  highest_block_indx = which((block_pillar_heights >
    block_pillar_heights[-1])[1:(length(block_pillar_heights)-1)])

  blocks_first_indx = block_pillars_indx[-length(block_pillars_indx)]
  blocks_second_indx = block_pillars_indx[-1]


}

cbind(tow, c(0, tow), tow > c(0, tow), diff(sign(input2)))
