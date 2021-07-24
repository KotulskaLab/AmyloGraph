#' @importFrom visNetwork visGetEdges visRemoveEdges visUpdateEdges
#' @importFrom dplyr `%>%`
visResetEdges <- \(graph, edges, input, selected_node_input_id,
                   legend = FALSE)
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(seq_along(input[["graph_edges_"]])) %>%
    visUpdateEdges(edges, legend) %>%
    visSelectNodes(input[[selected_node_input_id]])

#' @importFrom visNetwork visUnselectAll visSelectNodes
visToggleNodes <- \(graph, id) {
  if (length(id) == 0 || id == ag_option("str_null"))
    visUnselectAll(graph)
  else
    visSelectNodes(graph, id)
  graph
}