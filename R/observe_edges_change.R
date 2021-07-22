#' @importFrom shiny observe NS
#' @importFrom visNetwork visNetworkProxy
observe_edges_change <- function(input, edges_graph) {
  observe({
    visNetworkProxy("graph") %>% 
      visResetEdges(edges_graph, input,
                    NS("node_info", "select_node"))
  })
}