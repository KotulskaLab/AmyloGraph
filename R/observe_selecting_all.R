#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_selecting_all <- \(input, table_proxy) observeEvent(
  input[["deselect_all"]],
  selectRows(table_proxy, numeric())
)

#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_deselecting_all <- \(input, table_proxy, interactions_table) observeEvent(
  input[["select_all"]],
  selectRows(table_proxy, 1:nrow(interactions_table()))
)