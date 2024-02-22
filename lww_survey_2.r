library(readxl)
library(dplyr)
library(ggplot2)
library(scales)

dat = read_excel("")

dat <- dat %>%
  filter(!is.na(`Cryonics Status\nAre you signed up for cryonics?`)) %>%
  filter(!is.na(`P(Cryonics)\nWhat is the probability that an average person cryonically frozen today will be successfully restored to life at some future time, conditional on no global catastrophe destroying civilization before then?`))

dat$cryostatus_factor <- factor(dat$`Cryonics Status\nAre you signed up for cryonics?`, levels = c(
  "No - and do not want to sign up for cryonics",
  "Never thought about it / don't understand",
  "No - still considering it",
  "No - would like to sign up but haven't gotten around to it",
  "No - would like to sign up but unavailable in my area",
  "Yes - signed up or just finishing up paperwork"
), labels = c("Not interested", "Don't know about it", "Considering", "Cryocrastinating", "Unavailable in area", "Signed up"), ordered = TRUE)

# Let's check if any non-numeric values are present
dat <- dat %>%
  mutate(cryoprob_numeric = as.numeric(as.character(`P(Cryonics)\nWhat is the probability that an average person cryonically frozen today will be successfully restored to life at some future time, conditional on no global catastrophe destroying civilization before then?`))) %>%
  filter(!is.na(cryoprob_numeric)) %>%
  filter(cryoprob_numeric > 0)

# Now let's check how many NAs we have after conversion
print(sum(is.na(dat$cryoprob_numeric)))

# Calculate medians for each group after log transformation
median_cryoprob <- dat %>%
  group_by(cryostatus_factor) %>%
  summarize(median_prob = median(cryoprob_numeric, na.rm = TRUE)) %>%
  ungroup() %>% # Make sure data is ungrouped for ggplot
  mutate(log_median_prob = log10(median_prob)) # Apply log10 transformation to the median

# Find the range for the y-axis, making sure to include the smallest probability
range_of_probs <- range(log10(dat$cryoprob_numeric), finite = TRUE)

# Define a function for formatting the y-axis labels
format_y <- function(x) {
  ifelse(x < -2, 
         paste0("1e", x), 
         paste0(formatC(10^x, format = "f", digits = 2), "%"))
}

cryostatus_positions <- as.numeric(dat$cryostatus_factor)

median_cryoprob <- median_cryoprob %>%
  mutate(position = as.numeric(as.factor(cryostatus_factor)))

# Plotting
ggplot(dat, aes(x = cryostatus_factor, y = log10(cryoprob_numeric))) +
  geom_jitter(width = 0.3, alpha = 0.3) +
  scale_y_continuous(labels = format_y,
                     breaks = pretty(c(range_of_probs[1], range_of_probs[2]), n = 12),
                     limits = range_of_probs) +
  geom_segment(data = median_cryoprob, aes(x = position - 0.3, 
                                           xend = position + 0.3, 
                                           y = log_median_prob, 
                                           yend = log_median_prob), 
               color = "blue", size = 1) +
  theme_minimal() +
  labs(x = "Interest in Cryonics", y = "Subjective Probability of Success (Log Scale)") +
  theme(text = element_text(size = 12), axis.text.x = element_text(angle = 45, hjust = 1))
