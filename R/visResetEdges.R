#' @importFrom visNetwork visGetEdges visRemoveEdges visUpdateEdges
#' @importFrom dplyr `%>%`
visResetEdges <- function(graph, edges, input, legend = FALSE) {
  graph %>%
    visGetEdges("graph_edges_") %>%
    visGetSelectedNodes("graph_selected_nodes_") %>%
    visRemoveEdges(seq_along(input[["graph_edges_"]])) %>%
    visUpdateEdges(edges, legend) %>%
    visToggleNodes(input[["graph_selected_nodes_"]])
}