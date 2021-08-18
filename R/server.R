#' @importFrom shinyhelper observe_helpers
#' @importFrom shiny isolate observe updateSelectInput
#' @importFrom glue glue
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  edges <- graphControlServer("graph_control", ag_data[["interactions"]], ag_data[["groups"]])
  interactionsTableServer("all_edges", edges)
  nodeInfoServer("node_info", edges, ag_data[["nodes"]])
  interactionViewServer("interaction_view", ag_data[["interactions"]])
  
  output[["graph"]] <- render_network(ag_data[["nodes"]], edges)
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
}