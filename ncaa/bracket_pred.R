
#parameters for sim
#lower score for multiplier = more randomness
rpi_multiplier = 8

rpid = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/sos_wl_data_espn.txt", 
	skip = 1, header = T, sep = '\t', fill = T, quote = "")
	
midwest = read.table("/Users/amckenz/Documents/github/R-plots/ncaa/2015_bracket.txt", 
	header = F, sep = '\t')
midwest = gsub(" $", "", midwest$V1)

#clean up names to match RPI data
midwest = gsub("Wichita State", "Wichita St", midwest) 
midwest = gsub("New Mexico St.", "New Mexico St", midwest) 

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

result = replicate(1000, sim_division(midwest))

print(table(result))