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
reactive_selection_config <- function(rvals) {
  reactive({
    if (rvals[["table_visited"]]) {
      list(
        mode = "multiple",
        selected = rvals[["initially_selected"]],
        target = "row"
      )
    } else {
      "multiple"
    }
  })
}
