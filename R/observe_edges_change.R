#' Observes graph edges changing
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the graph.
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "graph" element.
#' 
#' @return An observer.
#' 
#' @importFrom shiny observe NS
#' @importFrom visNetwork visNetworkProxy
observe_edges_change <- function(input, edges) {
  observe({
    visNetworkProxy("graph") %>% 
      visResetEdges(edges[["graph"]], input, NS("single_protein", "select_node"))
  })
}