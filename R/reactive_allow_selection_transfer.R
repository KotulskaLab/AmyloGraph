#' Verify if "transfer selection" allowed
#' 
#' @description This function checks if it is allowed to transfer selection from
#' protein interaction tables to the main table. The requirements are that there
#' are rows selected in either interactors or interactees table, and "ignore
#' filters" option is not used.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the protein details.
#' 
#' @return A \code{reactive} object with a single boolean describing whether
#' transfering selection is allowed.
#' 
#' @importFrom shiny reactive
reactive_allow_selection_transfer <- function(input) {
  reactive({
    (!is.null(input[["interactees-table_rows_selected"]]) ||
       !is.null(input[["interactors-table_rows_selected"]])) &&
      !input[["ignore_filters"]]
  })
}
