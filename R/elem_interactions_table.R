#' @importFrom htmltools div
#' @importFrom DT dataTableOutput
elem_interactions_table <- function(id) div(
  id = "interactions_table",
  dataTableOutput(id)
)