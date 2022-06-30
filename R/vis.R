#' @importFrom visNetwork visNetwork visEdges visNodes visIgraphLayout
#'  visPhysics visOptions visInteraction
visAGNetwork <- function(nodes, edges) {
  visNetwork(nodes = nodes, edges = edges, width = 1600, height = 900) %>%
    visEdges(arrows = "to",
             width = 2,
             color = "#3674AB") %>%
    visNodes(color = "#F3C677",
             font = list(color = "#0C0A3E")) %>%
    visIgraphLayout(smooth = TRUE, physics = FALSE, randomSeed = 1338) %>%
    visPhysics(maxVelocity = 50, minVelocity = 49, timestep = 0.3) %>%
    visOptions(
      highlightNearest = list(enabled = TRUE, degree = 1,
                              labelOnly = FALSE, hover = TRUE,
                              algorithm = "hierarchical")) %>%
    visInteraction(zoomView = TRUE, navigationButtons = TRUE)
}

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
#' @importFrom purrr map_int
visResetEdges <- function(graph, edges, input, selected_node_input_id)
  graph %>%
    visGetEdges("graph_edges_") %>%
    visRemoveEdges(map_int(input[["graph_edges_"]], ~.x[["id"]]) %>% unname()) %>%
    visUpdateEdges(edges) %>%
    visSelectNodes(input[[selected_node_input_id]])

#' Reselect a node in a graph
#' 
#' @description Reselects a node (clearing a previous selection, if exists) or
#' deselects all nodes, depending on value of `id`.
#' 
#' @param graph \[\code{visNetwork_Proxy(1)}\]\cr
#'  Proxy of a graph to update.
#' @param id \[\code{character(0) | character(1)}\]\cr
#'  Node ID to verify.
#' 
#' @return The same proxy as in `graph` parameter, but updated.
#' 
#' @importFrom visNetwork visUnselectAll visSelectNodes
visToggleNodes <- \(graph, id) {
  if (is_node_selected(id))
    visSelectNodes(graph, id)
  else
    visUnselectAll(graph)
  graph
}
