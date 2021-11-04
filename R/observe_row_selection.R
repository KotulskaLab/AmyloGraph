observe_row_selection <- function(ns, any_row_selected) observe({
  toggleState(
    selector = glue("#{ns('table')} .ag-download-button"),
    condition = any_row_selected()
  )
  toggleCssClass(
    class = "ag-download-button-disabled",
    selector = glue("#{ns('table')} .ag-download-button"),
    condition = !any_row_selected()
  )
})