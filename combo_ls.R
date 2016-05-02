library(readxl)
library(ggplot2)

setwd("/Users/amckenz/Documents/lifestats/")

ls_files = list.files()
ls_files = ls_files[grep("ls", ls_files)]
ls_files = ls_files[grep("xlsx", ls_files)]
ls_files = ls_files[!grepl("omni", ls_files)]
ls_files = ls_files[!grepl("~", ls_files)]

total_df = NULL
for(i in ls_files){
  tmp = gsub(".xlsx", "", i, fixed = TRUE)
  print(i)
  tmp_df = read_excel(i)
  tmp_df = tmp_df[ , colnames(tmp_df) %in% c("Date", "sleep_tot", "work_tot")]
  str(tmp_df)
  total_df = rbind(total_df, data.frame(tmp_df))
}
total_df = total_df[!duplicated(total_df$Date), ]
total_df = total_df[order(total_df), ]
total_df = total_df[!is.na(total_df$Date), ]
total_df$work_tot = as.numeric(total_df$work_tot)
total_df$sleep_tot = as.numeric(total_df$sleep_tot)

date_work = ggplot(total_df, aes(x = Date, y = work_tot)) + geom_point() +
  theme_bw() + xlab("Date") + ylab("Total Hours Worked") + theme(text = element_text(size=20))

date_sleep = ggplot(total_df, aes(x = Date, y = sleep_tot)) + geom_point() +
  theme_bw() + xlab("Date")  + theme(text = element_text(size=20)) +
  scale_y_continuous(c(0, 15))+ ylab("Total Hours In Bed")

cor.test(total_df$work_tot[-nrow(total_df)], total_df$sleep_tot[-1], use = "na.or.complete",
  method = "spearman")
