#' @importFrom htmltools div
#' @importFrom DT dataTableOutput
elem_interactions_table <- function(id) div(
  class = "ag_interactions_table",
  dataTableOutput(id)
)