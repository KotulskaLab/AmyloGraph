library(ggplot2)
library(dplyr)
library(tidyr)

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

cairo_ps("database_summary.eps", height = 3.75, width = 7)
data.frame(interactions = c(NA, 863, 883),
                              proteins = c(NA, 49, 47),
                              manuscripts = c(364, 185, 173),
                              stage = c("Manuscript\ncollection", "Initial\ncuration", "Validation")) %>% 
  mutate(stage = factor(stage, levels = unique(stage))) %>% 
  pivot_longer(cols = -stage) %>% 
  na.omit() %>% 
  mutate(name = factor(name, 
                       levels = c("manuscripts", "proteins", "interactions"),
                       labels = c("Manuscripts", "Proteins", "Interactions"))) %>% 
  ggplot(aes(x = stage, y = value, label = value)) +
  geom_col() +
  geom_label(aes(y = value*0.5)) +
  scale_x_discrete("Stage of curation", na.translate = FALSE) +
  scale_y_continuous("Count") +
  facet_wrap(~ name, scales = "free") +
  theme_bw()
dev.off()
