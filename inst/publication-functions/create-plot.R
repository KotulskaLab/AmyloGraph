library(ggplot2)
library(dplyr)
library(tidyr)
library(ggh4x)
library(showtext)

font_add_google("Lato")
showtext_auto()

dat <- data.frame(interactions = c(NA, NA, 863, 883, 883),
                  manuscripts = c(24, 364, 185, 173, 173),
                  step = c("In-house collection", "Extended search", 
                           "Initial\ncuration", "Validation", "Contact with authors"),
                  stage = c("A) Pre-screen of manuscripts",
                            "A) Pre-screen of manuscripts",
                            "B) Manual curation", "B) Manual curation",
                            "C) Independent validation")) %>% 
  mutate(stage = factor(stage, levels = unique(stage)),
         step = factor(step, levels = unique(step))) %>% 
  pivot_longer(cols = c(interactions, manuscripts)) %>% 
  na.omit() %>% 
  mutate(name = factor(name, 
                       levels = c("manuscripts", "interactions"),
                       labels = c("Manuscripts", "Interactions")))

pdf("./inst/publication-functions/curation-plot.pdf", width = 9.5, height = 3.5)
ggplot(dat, aes(x = "a", y = value, label = value, fill = name)) +
  geom_col(position = position_dodge(width = 1)) + 
  geom_label(aes(y = ifelse(value < 50, value + 70, value/2)), 
             family = "Lato", position = position_dodge(width = 1), show.legend = FALSE) +
  scale_x_discrete("") +
  scale_y_continuous("Count") +
  scale_fill_manual("", values = c("#f1a340", "#998ec3")) +
  facet_nested_wrap(~ stage + step, scales = "free_x", nrow = 1) +
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid.major.x = element_blank(),
        legend.position = "bottom",
        text = element_text(family = "Lato"))
dev.off()

