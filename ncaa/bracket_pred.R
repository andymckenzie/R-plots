#idea here is to compare the frequency with which a team is predicted to go to the final four based on RPI-based simulation data with the frequency that that seed historically gets to the final four
#the most "surprising" teams predicted to get to the final four (vs historical trends) are the ones that you should pick 
#NOTE: still some bugs in here because the (non-midwest) teams are inputted in the wrong order for some of them, but going to sleep for now. otherwise, it works 

final_fours = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/final_fours.txt", 
	header = T, skip = 1, sep = '\t', quote = "", stringsAsFactors = F)
final_four_probs = table(as.numeric(gsub(" ", "", 
	unlist(strsplit(final_fours$SEEDS, ",")))))
#normalize to get probabilities 
final_four_probs = final_four_probs / sum(final_four_probs)
final_fours = as.data.frame(final_four_probs, stringsAsFactors = F)
row_to_add = data.frame(rbind(cbind(10, 0), 
	cbind(12, 0), 
	cbind(13, 0), 
	cbind(14, 0), 
	cbind(15, 0), 
	cbind(16, 0)))
names(row_to_add) = names(final_fours)
final_fours = rbind(final_fours, row_to_add)
final_fours$Var1 = as.numeric(final_fours$Var1)
mod = nls(Freq ~ exp(a + b * Var1), data = final_fours, start = list(a = 0, b = 0))

#plotting the results 
plot(final_fours$Var1, final_fours$Freq, xlab = "Seed", ylab = "Probability of Final Four") 
lines(final_fours$Var1, predict(mod, list(x = final_fours$Var1)))

###########################
### load data ###
###########################

rpid = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/sos_wl_data_espn.txt", 
	skip = 1, header = T, sep = '\t', fill = T, quote = "")
	
#order of these goes 1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15
midwest = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/2015_bracket_midwest.txt", 
	header = F, sep = '\t')
midwest = gsub(" $", "", midwest$V1)

#clean up names to match RPI data
midwest = gsub("Wichita State", "Wichita St", midwest) 
midwest = gsub("New Mexico St.", "New Mexico St", midwest) 

west = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/2015_bracket_west.txt", 
	header = F, sep = '\t')
west = gsub(" $", "", west$V1)
west = gsub("State", "St", west)
#exception
west = gsub("Ohio St", "Ohio State", west)
west = gsub("VCU", "Virginia Commonwealth", west)

south = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/2015_bracket_south.txt", 
	header = F, sep = '\t')
south = gsub(" $", "", south$V1)
south = gsub("State", "St", south)
#exception 
south = gsub("Iowa St", "Iowa State", south)

east = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/2015_bracket_east.txt", 
	header = F, sep = '\t')
east = gsub(" $", "", east$V1)
east = gsub("State", "St", east)
east = gsub("NC St", "NC State", east)

###########################
### parameters for sim ###
###########################

#lower score for multiplier = more randomness
rpi_multiplier = 5
replication_numbers = 1000 
midwest_flag = F
west_flag = F
east_flag = T
south_flag = F

###########################
### simulation ###
###########################

win_game <- function(team1, team2){
	#assume that the play in team loses, cause they almost definitely will
	#and we don't know which team they are for now so can't query their RPI 
	if(team1 == "Play_In"){
		return(team2)
	}
	if(team2 == "Play_In"){
		return(team1)
	}
	team1_rpi = rpid[rpid$TEAM == team1, ]$RPI
	team2_rpi = rpid[rpid$TEAM == team2, ]$RPI
	if((team1_rpi + runif(1)/rpi_multiplier) > (team2_rpi + runif(1)/rpi_multiplier)){
		return(team1)
	}
	else{
		return(team2)
	}
}

sim_division <- function(region_teams){
	second_round = vector()
	third_round = vector()
	fourth_round = vector()
	#first round
	for (i in seq(1, 16, 2)){
		winner = win_game(region_teams[i], region_teams[i+1]) 
		second_round[((i+1)/2)] = winner
	}
	#second round
	for (i in seq(1, 8, 2)){
		winner = win_game(second_round[i], second_round[i+1]) 
		third_round[(i/2)+1] = winner
	}
	#third round 
	for (i in seq(1, 4, 2)){
		winner = win_game(third_round[i], third_round[i+1]) 
		fourth_round[(i/2)+1] = winner
	}
	#fourth round
	div_winner = win_game(fourth_round[1], fourth_round[2])
	return(div_winner)
}

seed_order = c(1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15)
midwest_seeds = midwest[seed_order]
west_seeds = west[seed_order]
east_seeds = east[seed_order]
south_seeds = south[seed_order]

if(midwest_flag == TRUE){
	midwest_result = replicate(replication_numbers, sim_division(midwest))
	a = table(midwest_result)
	midwest_probs = a / sum(a)
	midwest_probs = as.data.frame(midwest_probs)

	for(i in 1:length(midwest)){
		if(midwest[i] %nin% midwest_probs$midwest_result){
			# print(midwest[i])
			row_to_add = data.frame(cbind(midwest[i], 0))
			names(row_to_add) = names(midwest_probs)
			midwest_probs = as.data.frame(rbind(midwest_probs, row_to_add))
		}	
	}

	#convert to character for ordering 
	midwest_probs$midwest_result = as.character(midwest_probs$midwest_result)
	midwest_probs = midwest_probs[match(midwest_seeds, midwest_probs$midwest_result), ]
	plot(midwest_probs$Freq, xlab = "Seed", ylab = "Probability of Final Four")
	lines(final_fours$Var1, predict(mod, list(x = final_fours$Var1)))
}

if(west_flag == TRUE){
	west_result = replicate(replication_numbers, sim_division(west))
	a = table(west_result)
	west_probs = a / sum(a)
	west_probs = as.data.frame(west_probs)

	for(i in 1:length(west)){
		if(west[i] %nin% west_probs$west_result){
			# print(west[i])
			row_to_add = data.frame(cbind(west[i], 0))
			names(row_to_add) = names(west_probs)
			west_probs = as.data.frame(rbind(west_probs, row_to_add))
		}	
	}

	#convert to character for ordering 
	west_probs$west_result = as.character(west_probs$west_result)
	west_probs = west_probs[match(west_seeds, west_probs$west_result), ]
	plot(west_probs$Freq, xlab = "Seed", ylab = "Probability of Final Four")
	lines(final_fours$Var1, predict(mod, list(x = final_fours$Var1)))
}

if(east_flag == TRUE){
	east_result = replicate(replication_numbers, sim_division(east))
	a = table(east_result)
	east_probs = a / sum(a)
	east_probs = as.data.frame(east_probs)

	for(i in 1:length(east)){
		if(east[i] %nin% east_probs$east_result){
			# print(east[i])
			row_to_add = data.frame(cbind(east[i], 0))
			names(row_to_add) = names(east_probs)
			east_probs = as.data.frame(rbind(east_probs, row_to_add))
		}	
	}

	#convert to character for ordering 
	east_probs$east_result = as.character(east_probs$east_result)
	east_probs = east_probs[match(east_seeds, east_probs$east_result), ]
	plot(east_probs$Freq, xlab = "Seed", ylab = "Probability of Final Four")
	lines(final_fours$Var1, predict(mod, list(x = final_fours$Var1)))
}

if(south_flag == TRUE){
	south_result = replicate(replication_numbers, sim_division(south))
	a = table(south_result)
	south_probs = a / sum(a)
	south_probs = as.data.frame(south_probs)

	for(i in 1:length(south)){
		if(south[i] %nin% south_probs$south_result){
			# print(south[i])
			row_to_add = data.frame(cbind(south[i], 0))
			names(row_to_add) = names(south_probs)
			south_probs = as.data.frame(rbind(south_probs, row_to_add))
		}	
	}

	#convert to character for ordering 
	south_probs$south_result = as.character(south_probs$south_result)
	south_probs = south_probs[match(south_seeds, south_probs$south_result), ]
	plot(south_probs$Freq, xlab = "Seed", ylab = "Probability of Final Four")
	lines(final_fours$Var1, predict(mod, list(x = final_fours$Var1)))
}
