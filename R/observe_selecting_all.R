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
#' @importFrom shiny observeEvent
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
#' @param table_id \[\code{character(1)}\]\cr
#'  ID of the table, from which to read \code{_rows_all}.
#' 
#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_selecting_all <- function(input, button_id, table_proxy,
                                  table_id = "table") {
  observeEvent(
    input[[button_id]],
    # TODO: remove glue after making sure that table_id is always "table"
    selectRows(table_proxy, input[[glue::glue("{table_id}_rows_all")]])
  )
}
