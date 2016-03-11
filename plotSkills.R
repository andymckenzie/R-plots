
#' @title Plot skills in a skills table.
#' @description A skills table has
#' @param skills_df Data frame in standard skills table format.
#' @return
plotSkills <- function(skills_df){
  library(ggplot2)
  skills_df = skills_df[order(skills_df$Level), ]
  skills_df$Topic = factor(skills_df$Topic, levels = skills_df$Topic)
  skills_df$Overall = factor(skills_df$Overall, levels = skills_df$Overall)
  palette = colorRampPalette(c("black", "#56B4E9", "#0072B2"))(n = length(unique(skills_df$Overall)))
  skills = ggplot(skills_df, aes(x = Topic, y = Level, fill = Overall)) +
    geom_bar(stat = 'identity')  + ylab("") + xlab("") +
    coord_flip() + theme_bw() + #ylim = c(0,1)
    theme(axis.line = element_line(colour = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank()) +
    scale_fill_manual(values = palette, guide = guide_legend(title = "", reverse = TRUE))
  return(skills)
}

programming = read.table("/Users/amckenz/Documents/packages/chancy/Skills\ -\ Programming.tsv", sep = "\t", header = TRUE)
life_skills = read.table("/Users/amckenz/Documents/packages/chancy/Skills\ -\ Life\ Skills.tsv", sep = "\t", header = TRUE)
medicine = read.table("/Users/amckenz/Documents/packages/chancy/Skills\ -\ Medicine.tsv", sep = "\t", header = TRUE)
statistics = read.table("/Users/amckenz/Documents/packages/chancy/Skills\ -\ Statistics.tsv", sep = "\t", header = TRUE)

plotSkills(programming)
plotSkills(life_skills)
plotSkills(medicine)
plotSkills(statistics)
