#' @importFrom shinyhelper observe_helpers
#' @importFrom shiny isolate observe updateSelectInput
#' @importFrom glue glue
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  edges <- server_filter_control("filter_control", ag_data[["interactions"]], ag_data[["groups"]])
  subtables <- server_single_protein("single_protein", edges, ag_data[["nodes"]])
  
  server_interactions_table("interactions_table", edges)
  server_single_interaction("single_interaction", ag_data[["interactions"]])
  server_db_statistics("db_statistics", ag_data[["interactions"]], ag_data[["nodes"]])
  
  output[["graph"]] <- render_network(ag_data[["nodes"]], edges)
  output[["ag_version"]] <- render_ag_version()
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
}
