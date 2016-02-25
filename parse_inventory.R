inventory = read.delim("/Users/amckenz/Desktop/inventory.tsv", quote = "")
#http://stackoverflow.com/questions/10502787/removing-trailing-spaces-with-gsub-in-r
inventory$Category_clean = gsub("[[:space:]]*$", "", inventory$Category)
table(inventory$Category_clean) 

inventory[inventory$Category_clean == "Sleep", ]
