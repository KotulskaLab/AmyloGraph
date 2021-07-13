#' @importFrom visNetwork visUnselectAll visSelectNodes
visToggleNodes <- function(graph, id) {
  if (id == getOption("ag_str_null"))
    visUnselectAll(graph)
  else
    visSelectNodes(graph, id)
  graph
}