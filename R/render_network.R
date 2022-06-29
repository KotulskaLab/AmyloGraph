#' Render visNetwork graph
#' 
#' @description Renders a visNetwork graph using initial AmyloGraph data. Any
#' changes to the graph should be done through `visNetworkProxy()` inside an
#' observer in other parts of code.
#' 
#' @param ag_data_nodes \[\code{data.frame()}\]\cr
#'  Output of \code{\link{ag_data_nodes}()}, nodes to plot.
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "graph" element, edges to plot.
#' 
#' @importFrom visNetwork renderVisNetwork visNetwork visEdges visOptions
#'  visInteraction visEvents visIgraphLayout visExport visNodes visPhysics
render_network <- function(ag_data_nodes, edges) {
  initial_center <- load_js_code("initial_center")
  
  renderVisNetwork({
    # We don't want to render graph each time we modify edges
    # Instead we update them in a separate observer using visNetworkProxy()
    visNetwork(ag_data_nodes, isolate(edges[["graph"]]),
               width = 1600, height = 900) %>%
      visEdges(arrows = "to", 
               width = 2,
               color = "#3674AB") %>% 
      visNodes(color = "#F3C677",
               font = list(color = "#0C0A3E")) %>%
      visIgraphLayout(smooth = TRUE, physics = FALSE, randomSeed = 1338) %>%
      visPhysics(maxVelocity = 50, minVelocity = 49, timestep = 0.3) %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1,
                                labelOnly = FALSE, hover = TRUE,
                                algorithm = "hierarchical")) %>%
      visInteraction(zoomView = TRUE, navigationButtons = TRUE) %>%
      visEvents(
        selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
        deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>"),
        release = if (ag_option("center_network")) initial_center else NULL) %>%
      visExport(type = "png", name = "AmyloGraph", label = "Export as png", float = "left", 
                style = "")
  })
}