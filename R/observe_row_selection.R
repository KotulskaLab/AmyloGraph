observe_row_selection <- function(ns, button_id, any_row_selected) {
  observe({
    toggleState(
      selector = glue("#{ns('table')} .ag-download-button"),
      condition = any_row_selected()
    )
    toggleCssClass(
      class = "ag-download-button-disabled",
      selector = glue("#{ns('table')} .ag-download-button"),
      condition = !any_row_selected()
    )
    
    toggleState(
      selector = glue("#{ns(button_id)}"),
      condition = any_row_selected()
    )
    toggleCssClass(
      class = "ag-selection-button-disabled",
      selector = glue("#{ns(button_id)}"),
      condition = !any_row_selected()
    )
  })
}