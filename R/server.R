#' @importFrom shinyhelper observe_helpers
#' @importFrom visNetwork renderVisNetwork visNetwork visEdges visLayout visOptions visInteraction
#' @importFrom visNetwork visEvents visIgraphLayout visExport visNetworkProxy
#' @importFrom shiny isolate observe updateSelectInput
#' @importFrom glue glue
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  edges <- graphControlServer(
    "graph_control", 
    ag_data[["ag_data_interactions"]], 
    ag_data[["ag_data_groups"]]
    )
  
  interactionsTableServer("all_edges", edges)
  
  output[["graph"]] <- renderVisNetwork({
    # we don't want to render graph each time we modify edges
    # instead we remove and update them in a separate observer
    visNetwork(ag_data[["ag_data_nodes"]], isolate(edges[["graph"]]),
               width = 1600, height = 900) %>%
      visEdges(arrows = "to", width = 2)  %>% 
      visLayout(randomSeed = 1337) %>% 
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1,
                                labelOnly = FALSE, hover = TRUE,
                                algorithm = "hierarchical")) %>%
      visInteraction(zoomView = TRUE) %>%
      visEvents(
        selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
        deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>")) %>%
      visIgraphLayout(smooth = TRUE) %>%
      visExport(type = "png", name = "AmyloGraph", label = "Export as png")
  })
  
  nodeInfoServer("node_info", edges, ag_data[["ag_data_nodes"]])
  
  observe({
    selected_node_id <- input[[NS("node_info", "select_node")]]
    visNetworkProxy("graph") %>%
      visToggleNodes(selected_node_id)
    updateSelectInput(
      inputId = NS("node_info", "select_node"),
      selected = selected_node_id
    )
  })
  
  observe({
    visNetworkProxy("graph") %>% 
      visResetEdges(edges[["graph"]], input,
                    NS("node_info", "select_node"))
  })
}