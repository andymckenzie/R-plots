
library(gtools)
library(IRanges)
library(seqinr)

ex = read.fasta("/Users/amckenz/Downloads/rosalind_lcsm.txt")

strings = string_names = vector()
for(i in 1:length(ex)){
  strings[i] = toupper(paste(ex[[i]], sep = "", collapse = ""))
}

#start at 6 or so, can change this
combos = permutations(4, 6, c("A", "C", "G", "T"), repeats.allowed = TRUE, set = TRUE)
combos = apply(combos, 1, paste, sep = "", collapse = "")
for(i in 1:50){
  # combos_rev = reverse(combos)
  # combos = unique(c(combos, combos_rev))
  # if("AAAATTTC" %in% combos) break
  if(length(matches > 0)){
    matches = unique(matches)
    combos = vector()
    for(j in 1:length(matches)){
      for(k in c("A", "C", "G", "T")){
        combos = c(combos, paste0(matches[j], k, collapse = ""))
        combos = c(combos, paste0(k, matches[j], collapse = ""))
      }
    }
  }
  combos = unique(combos)
  matches = vector()
  for(j in 1:length(combos)){
    all_flag = TRUE
    for(k in 1:length(strings)){
      if(!grepl(combos[j], strings[k])){
        all_flag = FALSE
      }
    }
    if(all_flag){
      print("this one works for all strings")
      print(combos[j])
      matches = c(matches, combos[j])
    }
  }
  print(length(combos))
  print(nchar(combos[1]))
  if(length(matches) == 0){
    print("breaking")
    break
  }
}

confirm = "AAAATTTCATCCACG" #CGGGGTT #AAAATTTC #AAAATTTCA #AAAATTTCAT #AAAATTTCATC #AAAATTTCATCC #AAAATTTCATCCAC

for(k in 1:length(strings)){
  if(grepl(confirm, strings[k])){
    print("TRUE")
  } else {
    print("FALSE")
  }
}
