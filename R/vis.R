#' @importFrom visNetwork visGetEdges visRemoveEdges visUpdateEdges
#' @importFrom dplyr `%>%`
#' @importFrom purrr map_int
visResetEdges <- \(graph, edges, input, selected_node_input_id,
                   legend = FALSE)
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(map_int(input[["graph_edges_"]], ~.x[["id"]]) %>% unname()) %>%
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