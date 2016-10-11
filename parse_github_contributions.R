
github_contribs = readLines("https://github.com/users/andymckenzie/contributions")
data_days = github_contribs[grep("data-count", github_contribs)]
data_days_split = strsplit(data_days, "\"", fixed = TRUE)

counts = sapply(data_days_split, "[[", 14)
days = sapply(data_days_split, "[[", 16)

counts30 = as.numeric(tail(counts, 30))
days30 = as.Date(tail(days, 30), format = "%Y-%m-%d")
contribs = data.frame(counts30, days30)
contribs_weekdays = contribs[!weekdays(contribs$days30) %in% c("Saturday", "Sunday"), ]

plot(contribs_weekdays$days30, contribs_weekdays$counts30)
