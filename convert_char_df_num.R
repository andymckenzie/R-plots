char_df = read.table("char_df.txt", col.names = TRUE)

char_df_char = apply(char_df, 2, as.character)
