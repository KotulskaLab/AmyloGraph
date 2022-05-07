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
observe_deselecting_all <- \(input, button_id, table_proxy) observeEvent(
  input[[button_id]],
  selectRows(table_proxy, numeric())
)

#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_selecting_all <- \(input, button_id, table_proxy, interactions_table) observeEvent(
  input[[button_id]],
  selectRows(table_proxy, 1:nrow(interactions_table()))
)