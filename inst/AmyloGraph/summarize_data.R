library(ggplot2)
library(dplyr)

dat <- AmyloGraph::ag_data_interactions()

nrow(dat)
length(unique(dat[["doi"]]))

annot_text <- paste0("Total number of publications: ", length(unique(dat[["doi"]])), "\n",
                     "Total number of interactions: ", nrow(dat))


png("database_summary.png", height = 440, width = 840)
dat %>% 
  count(doi) %>% 
  count(n, name = "freq") %>% 
  ggplot(aes(x = n, y = freq)) +
  geom_col() +
  annotate("text", x = 20, y = 40, label = annot_text, size = 8) +
  scale_x_continuous("Number of interactions per publication") +
  scale_y_continuous("Number of publications") +
  theme_bw(base_size = 14)
dev.off()
