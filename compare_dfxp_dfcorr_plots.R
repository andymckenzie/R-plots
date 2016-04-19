
library(ggplot2)

setwd("/Users/amckenz/Dropbox/zhang/diffcorr")

gene_a_df = data.frame(rna = c(5, 3, 7, 4, 6, 3, 2, 5, 4, 6), condition = rep(c("a", "b"), each = 5))

gene_a_df_dfxp = ggplot(data = gene_a_df, aes(x = as.factor(condition), y = rna)) +
  geom_point() + theme_bw() + ylim(0, 10) + xlab("") + ylab("")

ggsave(gene_a_df_dfxp, file = "gene_a_df_dfxp_sim.jpg", height = 2, width = 2)

gene_b_df = data.frame(rna = c(4, 3, 7, 4, 5, 2, 4, 3, 3, 3), condition = rep(c("a", "b"), each = 5))

gene_b_df_dfxp = ggplot(data = gene_b_df, aes(x = as.factor(condition), y = rna)) +
  geom_jitter(height = 0, width = 0.3) + theme_bw() + ylim(0, 10) + xlab("") + ylab("")

ggsave(gene_b_df_dfxp, file = "gene_b_df_dfxp_sim.jpg", height = 2, width = 2)

gene_both_df = data.frame(rna1 = c(5, 3, 7, 4, 6, 3, 2, 5, 4, 6), rna2 = c(4, 3, 7, 4, 5, 2, 4, 3, 3, 3),
  condition = rep(c("a", "b"), each = 5))
gene_both_df_a = gene_both_df[gene_both_df$condition == "a", ]

gene_both_df_a_corr = ggplot(gene_both_df_a, aes(x = rna1, y = rna2)) + xlab("") + ylab("") +
  geom_point() + stat_smooth(method = "lm") + theme_bw() + ylim(0, 10) + xlim(0, 10)

ggsave(gene_both_df_a_corr, file = "gene_both_df_a_corr_sim.jpg", height = 2, width = 2)

gene_both_df_b = gene_both_df[gene_both_df$condition == "b", ]

gene_both_df_b_corr = ggplot(gene_both_df_b, aes(x = rna1, y = rna2)) + xlab("") + ylab("") +
  geom_point() + stat_smooth(method = "lm") + theme_bw() + ylim(0, 10) + xlim(0, 10)

ggsave(gene_both_df_b_corr, file = "gene_both_df_b_corr_sim.jpg", height = 2, width = 2)
