visToggleNodes <- function(graph, id, nullValue = STR_NULL) {
  if (id == nullValue)
    visUnselectAll(graph)
  else
    visSelectNodes(graph, id)
  graph
}