#' @importFrom glue glue
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}

is_node_selected <- function(id) {
  length(id) == 0 || id == ag_option("str_null")
}