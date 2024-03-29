#' Remove selections in a table
#' 
#' @description Sets selected rows to none in a table in response to clicking
#' a button.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the table.
#' @param button_id \[\code{character(1)}\]\cr
#'  ID of a button that triggers removing selections.
#' @param table_proxy \[\code{dataTableProxy(1)}\]\cr
#'  Proxy of a table to update.
#' 
#' @importFrom DT selectRows
observe_deselecting_all <- function(input, button_id, table_proxy) {
  observeEvent(
    input[[button_id]],
    selectRows(table_proxy, numeric())
  )
}

#' Select all rows in a table
#' 
#' @description Sets selected rows to all in a table in response to clicking
#' a button.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the table.
#' @param button_id \[\code{character(1)}\]\cr
#'  ID of a button that triggers adding selections.
#' @param table_proxy \[\code{dataTableProxy(1)}\]\cr
#'  Proxy of a table to update.
#' 
#' @importFrom DT selectRows
observe_selecting_all <- function(input, button_id, table_proxy) {
  observeEvent(
    input[[button_id]],
    selectRows(table_proxy, input[["table_rows_all"]])
  )
}
