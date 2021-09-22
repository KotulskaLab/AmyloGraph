library(ggplot2)

dat <- readr::read_csv(system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
         col_types = "ccccfffcc")

nrow(dat)
length(unique(dat[["doi"]]))

table(dat[["doi"]]) %>% 
  data.frame() %>% 
  select(Freq) %>% 
  table(n_interaction = .) %>% 
  data.frame() %>% 
  mutate(n_interaction = as.numeric(as.character(n_interaction))) %>% 
  ggplot(aes(x = n_interaction, y = Freq)) +
  geom_col() +
  geom_text(x = 25, y = 40, label = paste0("Total number of publications: ", length(unique(dat[["doi"]])))) +
  scale_x_continuous("Number of interactions per publication") +
  scale_y_continuous("Number of publications") +
  theme_bw()
