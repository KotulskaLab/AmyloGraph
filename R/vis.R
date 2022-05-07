#' Clear and update edges in a graph
#' 
#' @description Clears all existing edges and creates new ones, then reselects
#' a node.
#' 
#' @param graph \[\code{visNetwork_Proxy(1)}\]\cr
#'  Proxy of a graph to update.
#' @param edges \[\code{data.frame()}\]\cr
#'  AmyloGraph graph data.
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the graph.
#' @param selected_node_input_id \[\code{character(1)}\]\cr
#'  ID of the selected node (protein) to reselect.
#' 
#' @return The same proxy as in `graph` parameter, but updated.
#' 
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