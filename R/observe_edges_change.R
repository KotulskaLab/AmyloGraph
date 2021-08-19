#' @importFrom shiny observe NS
#' @importFrom visNetwork visNetworkProxy
observe_edges_change <- function(input, edges) {
  observe({
    visNetworkProxy("graph") %>% 
      visResetEdges(edges[["graph"]], input, NS("single_protein", "select_node"))
  })
}