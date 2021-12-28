library(shiny, quietly = TRUE)

ag_data <- ag_load_data()

rvals <- reactiveValues(
  table_visited = FALSE,
  initally_selected = NULL
)

edges <- reactiveValues(
  table = NULL,
  graph = NULL,
  node_info = NULL
)
