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