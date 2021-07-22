#' @importFrom visNetwork renderVisNetwork visNetwork visEdges visLayout visOptions visInteraction
#' @importFrom visNetwork visEvents visIgraphLayout visExport
render_network <- function(ag_data_nodes, edges_graph) {
  renderVisNetwork({
    # we don't want to render graph each time we modify edges
    # instead we remove and update them in a separate observer
    visNetwork(ag_data_nodes, isolate(edges_graph),
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
}