visResetEdges <- function(graph, edges, input, legend = FALSE) {
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(seq_along(input[["graph_edges_"]])) %>%
    visUpdateEdges(edges, legend)
}