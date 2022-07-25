#' Construct DT selection config
#' 
#' @description Constructs selection configuration for the main table according
#' to DataTable specification. It's required due to table proxy not being
#' available before rendering the table first.
#' 
#' @param rvals \[\code{reactivevalues()}\]\cr
#'  Information about table having been visited and rows selected in single
#'  protein tables.
#' 
#' @return Value to use as `selection` parameter in `renderDataTable()`, either
#' a list or a string.
reactive_selection_config <- function(tabs_visited, initial_selection) {
  reactive({
    if (tabs_visited[["table"]]) {
      list(
        mode = "multiple",
        selected = initial_selection(),
        target = "row"
      )
    } else {
      "multiple"
    }
  })
}
