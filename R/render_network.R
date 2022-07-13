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
render_network <- function(edges) {
  initial_center <- load_js_code("initial_center")
  
  renderVisNetwork({
    # We don't want to render graph each time we modify edges
    # Instead we update them in a separate observer using visNetworkProxy()
    visAGNetwork(isolate(edges[["graph"]])) %>%
      visEvents(
        selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
        deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>"),
        release = if (ag_option("center_network")) initial_center else NULL) %>%
      visExport(type = "png", name = "AmyloGraph", float = "left", style = "")
  })
}
