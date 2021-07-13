source("R/LabelData.R")

DATA_PATH <- "./interactions_data.csv"
LABEL_PALETTE <- palette("Dark 2")
LABEL_GROUPS <- tibble::tribble(
  ~ id, ~ name,
  "aggregation_speed", "interactee aggregation speed",
  "elongates_by_attaching", "elongates by attaching",
  "heterogenous_fibers", "heterogenous fibers"
)

edge_data <- read.csv(DATA_PATH) %>%
  mutate(from_id = map_chr(interactor_name, digest),
         to_id = map_chr(interactee_name, digest))

node_data <- select(edge_data, interactor_name, interactee_name) %>% 
  unlist() %>% 
  unique() %>% 
  tibble(label = .,
         id = map_chr(label, digest),
         shape = "box")

label_data <- LabelData(LABEL_GROUPS, LABEL_PALETTE, edge_data)

rm(DATA_PATH, LABEL_PALETTE, LABEL_GROUPS)
