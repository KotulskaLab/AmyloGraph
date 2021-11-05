toggle_state_and_css <- function(selector, class, condition) observe({
  toggleState(
    selector = selector,
    condition = condition()
  )
  toggleCssClass(
    class = class,
    selector = selector,
    condition = !condition()
  )
})

observe_download_button <- function(ns, any_row_selected) toggle_state_and_css(
  glue("#{ns('table')} .ag-download-button"),
  "ag-download-button-disabled",
  any_row_selected
)

observe_deselect_button <- function(ns, button_id, any_row_selected) toggle_state_and_css(
  glue("#{ns(button_id)}"),
  "ag-deselection-button-disabled",
  any_row_selected
)

observe_select_in_table_button <- function(ns, any_row_selected) toggle_state_and_css(
  glue("#{ns('select_in_table')}"),
  "ag-moveselection-button-disabled",
  any_row_selected
)
