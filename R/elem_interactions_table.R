#' @importFrom htmltools div
#' @importFrom shiny dataTableOutput
elem_interactions_table <- function(id) div(
  class = "ag-table-panel",
  dataTableOutput(id)
)