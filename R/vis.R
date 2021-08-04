#' @importFrom visNetwork visGetEdges visRemoveEdges visUpdateEdges
#' @importFrom dplyr `%>%`
visResetEdges <- \(graph, edges, input, selected_node_input_id,
                   legend = FALSE)
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(seq_along(isolate(input[["graph_edges_"]]))) %>%
    visUpdateEdges(edges, legend) %>%
    visSelectNodes(input[[selected_node_input_id]])

#' @importFrom visNetwork visUnselectAll visSelectNodes
visToggleNodes <- \(graph, id) {
  if (is_node_selected(id))
    visSelectNodes(graph, id)
  else
    visUnselectAll(graph)
  graph
}