library(readxl)
library(ggplot2)
library(zoo)

setwd("/Users/amckenz/Documents/lifestats/")

ls_files = list.files()
ls_files = ls_files[grep("ls", ls_files)]
ls_files = ls_files[grep("xlsx", ls_files)]
ls_files = ls_files[!grepl("omni", ls_files)]
ls_files = ls_files[!grepl("~", ls_files)]

total_df = NULL
stress_df = NULL
#ex_tot ex_time "Workout time" Workout Time
for(i in ls_files){
  tmp = gsub(".xlsx", "", i, fixed = TRUE)
  print(i)
  tmp_df = read_excel(i)
  assign(tmp, tmp_df)

  tmp_df1 = tmp_df[ , colnames(tmp_df) %in% c("Date", "sleep_tot", "work_tot")]
  tmp_df2 = tmp_df[ , colnames(tmp_df) %in% c("ex_tot", "ex_time", "Workout time", "Workout Time")]
  #convert minutes to hours
  if(max(tmp_df2, na.rm = TRUE) > 10){
    tmp_df2 = tmp_df2/60
  }
  if(sum(is.na(tmp_df2)) > 10){
    print("NA"); print(sum(is.na(tmp_df2))); print(head(tmp_df2, 20))
    tmp_df2[is.na(tmp_df2)] = 0
  }
  tmp_df_keep = data.frame(tmp_df1, tmp_df2)
  colnames(tmp_df_keep) = c("Date", "sleep_tot", "work_tot", "ex_tot")
  total_df = rbind(total_df, tmp_df_keep)

  colnames_lower = tolower(colnames(tmp_df))
  colname_stress = grepl("stress level", colnames_lower)
  if(sum(colname_stress) > 0){
    print("found stress")
    tmp_date = tmp_df[ , colnames(tmp_df) %in% c("Date"), drop = FALSE]
    tmp_stress = tmp_df[ , colname_stress, drop = FALSE]
    tmp_stress_df = data.frame(tmp_date, tmp_stress)
    colnames(tmp_stress_df) = c("Date", "Stress")
    str(tmp_stress_df)
    str(stress_df)
    stress_df = rbind(stress_df, tmp_stress_df)
  }
}

total_df = total_df[!duplicated(total_df$Date), ]
total_df = total_df[order(total_df), ]
total_df = total_df[!is.na(total_df$Date), ]
total_df$work_tot = as.numeric(total_df$work_tot)
total_df$sleep_tot = as.numeric(total_df$sleep_tot)
total_df$ex_tot = as.numeric(total_df$ex_tot)

#calculate moving averages
total_df$work_tot_mean = rollapply(total_df$work_tot, na.pad = TRUE, FUN = mean, width = 10, na.rm = TRUE)
total_df$ex_tot_mean = rollapply(total_df$ex_tot, na.pad = TRUE, FUN = mean, width = 10, na.rm = TRUE)
total_df$sleep_tot_mean = rollapply(total_df$sleep_tot, na.pad = TRUE, FUN = mean, width = 10, na.rm = TRUE)

stress_df$Stress_mean = rollapply(stress_df$Stress, na.pad = TRUE, FUN = mean, width = 10, na.rm = TRUE)

date_work = ggplot(total_df, aes(x = Date, y = work_tot)) + geom_point() +
  theme_bw() + xlab("Date") + ylab("Total Hours Worked") + theme(text = element_text(size=20)) +
  geom_line(aes(x = Date, y = work_tot_mean, colour = "blue"))

date_sleep = ggplot(total_df, aes(x = Date, y = sleep_tot)) + geom_point() +
  theme_bw() + xlab("Date")  + theme(text = element_text(size=20)) +
  scale_y_continuous(name = "Total Hours In Bed", limits = c(0, 15)) + ylab("Total Hours In Bed") +
  geom_line(aes(x = Date, y = sleep_tot_mean, colour = "blue"))

date_ex = ggplot(total_df, aes(x = Date, y = ex_tot)) + geom_point() +
  theme_bw() + xlab("Date")  + theme(text = element_text(size=20)) +
  # scale_y_continuous(limits = c(0, 15)) +
  ylab("Exercise") +
  geom_line(aes(x = Date, y = ex_tot_mean, colour = "blue"))

date_stress = ggplot(stress_df, aes(x = Date, y = Stress)) + geom_point() +
  theme_bw() + xlab("Date")  + theme(text = element_text(size=20)) +
  ylab("Stress Rating") +
  geom_line(aes(x = Date, y = Stress_mean, colour = "blue"))


cor.test(total_df$work_tot[-nrow(total_df)], total_df$sleep_tot[-1], use = "na.or.complete",
  method = "spearman")
