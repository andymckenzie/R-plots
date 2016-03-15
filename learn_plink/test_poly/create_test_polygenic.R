#make a test PED and a test MAP, and then convert them to BED, BIM, and FAM using --makebed
#also make a corresponding test
#finally, make a corresponding test geneset file
#should be able to manually calculate the polygenic score for each participant in each geneset, and in the total
#and can confirm whether or not plink is calculating it properly, +/- send it to Chris Chang

#need a test PED
#http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml

ped = as.data.frame(rbind(
  c(1, 1, 0, 0, 0, -9, "A", "A", "C", "G", "A", "T", "A", "G"),
  c(2, 2, 0, 0, 0, -9, "A", "G", "C", "C", "A", "A", "A", "A")))

#a test MAP
map = as.data.frame(rbind(
  c(1, "rs234567", 0, 123456),
  c(2, "rs345678", 0, 234567),
  c(3, "rs456789", 0, 345678),
  c(4, "rs567890", 0, 456789)))

#a test polygenic score file
#    SNP ID
#      Reference allele
#      Score (numeric)
score = as.data.frame(rbind(
  c("rs234567", "A", 1.5),
  c("rs345678", "C", 1.4),
  c("rs456789", "A", 1.3),
  c("rs567890", "A", 1.2)))

#and a test gene set file
set = c(
  "red", "rs234567", "rs345678", "END", "",
  "blue", "rs456789", "rs567890", "END", "",
  "green", "rs234567", "END", "",
  "orange", "rs567890", "END", "")

write.table(ped, "/Users/amckenz/Dropbox/zhang/adni/test_poly/test.ped",
  col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(map, "/Users/amckenz/Dropbox/zhang/adni/test_poly/test.map",
  col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(score, "/Users/amckenz/Dropbox/zhang/adni/test_poly/test_score.raw",
  col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(set, "/Users/amckenz/Dropbox/zhang/adni/test_poly/test.set",
  col.names = FALSE, row.names = FALSE, quote = FALSE)
