library(ggplot2)
library(dplyr)

dat <- readr::read_csv(system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
         col_types = "ccccfffcc")

nrow(dat)
length(unique(dat[["doi"]]))

annot_text <- paste0("Total number of publications: ", length(unique(dat[["doi"]])), "\n",
                     "Total number of interactions: ", nrow(dat))


png("database_summary.png", height = 440, width = 840)
table(dat[["doi"]]) %>% 
  data.frame() %>% 
  select(Freq) %>% 
  table(n_interaction = .) %>% 
  data.frame() %>% 
  mutate(n_interaction = as.numeric(as.character(n_interaction))) %>% 
  ggplot(aes(x = n_interaction, y = Freq)) +
  geom_col() +
  annotate("text", x = 20, y = 40, label = annot_text, size = 8) +
  scale_x_continuous("Number of interactions per publication") +
  scale_y_continuous("Number of publications") +
  theme_bw(base_size = 14)
dev.off()

