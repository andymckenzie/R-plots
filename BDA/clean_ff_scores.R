library(readxl)

asdf = read_excel("ff_fleaflicker_data.xlsx", col_names = F)
asdf = as.data.frame(asdf)

list_of_weekly_scores =  vector("list", nrow(asdf))

for(i in 1:nrow(asdf)){
  a = strsplit(as.character(asdf$X0[i]), " ")[[1]]

  #remove names characters -- may need to change this
  a = a[!a == "Jes.."]
  a = a[!a == "The"]
  a = a[!a == "Tub"]
  a = a[!a == "e.."]
  a = a[!a == "is"]
  a = a[!a == "from"]
  a = a[!a == "Gr.."]
  a = a[!a == "Kill.."]
  a = a[!a == "\"Sesh\""]
  a = a[!a == ".."]
  a = a[!a == "Jim's"]

  #split into a names vector and a scores vector
  b <- a[seq(1, length(a), 2)]
  c <- a[seq(2, length(a), 2)]
  scores = data.frame(b, c)
  list_of_weekly_scores[[i]] = scores
}

merged_scores = Reduce(function(...) merge(..., by = "b", all=T),
  list_of_weekly_scores)
