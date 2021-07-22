#' @importFrom visNetwork visUnselectAll visSelectNodes
visToggleNodes <- function(graph, id) {
  if (length(id) == 0 || id == ag_option("str_null"))
    visUnselectAll(graph)
  else
    visSelectNodes(graph, id)
  graph
}