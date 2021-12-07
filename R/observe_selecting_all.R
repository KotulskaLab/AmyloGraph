#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_deselecting_all <- \(input, button_id, table_proxy) observeEvent(
  input[[button_id]],
  selectRows(table_proxy, numeric())
)

#' @importFrom DT selectRows
#' @importFrom shiny observeEvent
observe_selecting_all <- \(input, button_id, table_proxy, table_id) observeEvent(
  input[[button_id]],
  # TODO: remove glue after making sure that table_id is always "table"
  selectRows(table_proxy, input[[glue::glue("{table_id}_rows_all")]])
)