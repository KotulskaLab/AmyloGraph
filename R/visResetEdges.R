#' @importFrom visNetwork visGetEdges visRemoveEdges visUpdateEdges
#' @importFrom dplyr `%>%`
visResetEdges <- function(graph, edges, input, selected_node_input_id,
                          legend = FALSE) {
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(seq_along(input[["graph_edges_"]])) %>%
    visUpdateEdges(edges, legend) %>%
    visSelectNodes(input[[selected_node_input_id]])
}