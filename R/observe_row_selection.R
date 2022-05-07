#' Enable/disable element with CSS styling
#' 
#' @description Toggles element state and sets CSS class to allow customizing
#' the look of elements when disabled (very useful to differentiate them from
#' enabled elements).
#' 
#' @param selector \[\code{character(1)}\]\cr
#'  Query selector of the elements to target.
#' @param class \[\code{character(1)}\]\cr
#'  Class to add when condition is not satisfied.
#' @param condition \[\code{function(1)}\]\cr
#'  Function that takes no parameters and evaluates to either `TRUE` or `FALSE`.
#' 
#' @importFrom shinyjs toggleState toggleCssClass
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

#' Observe "Download" button
#' 
#' @description Toggles button on and off based on whether any row is selected
#' in a table.
#' 
#' @param ns \[\code{function(1)}\]\cr
#'  Namespace-generating function that takes single string as the only argument.
#' @param any_row_selected \[\code{reactive(logical(1))}\]\cr
#'  A reactive value telling whether any row is selected in a table.
#' 
#' @importFrom glue glue
observe_download_button <- function(ns, any_row_selected) toggle_state_and_css(
  glue("#{ns('table')} .ag-download-button"),
  "ag-download-button-disabled",
  any_row_selected
)

#' Observe "Deselect" button
#' 
#' @description Toggles button on and off based on whether any row is selected
#' in a table.
#' 
#' @param ns \[\code{function(1)}\]\cr
#'  Namespace-generating function that takes single string as the only argument.
#' @param button_id \[\code{character(1)}\]\cr
#'  ID of the "Deselect" button to observe.
#' @param any_row_selected \[\code{reactive(logical(1))}\]\cr
#'  A reactive value telling whether any row is selected in a table.
#' 
#' @importFrom glue glue
observe_deselect_button <- function(ns, button_id, any_row_selected) toggle_state_and_css(
  glue("#{ns(button_id)}"),
  "ag-deselection-button-disabled",
  any_row_selected
)

#' Observe "Transfer selection" button
#' 
#' @description Toggles button on and off based on whether any row is selected
#' in a table.
#' 
#' @param ns \[\code{function(1)}\]\cr
#'  Namespace-generating function that takes single string as the only argument.
#' @param any_row_selected \[\code{reactive(logical(1))}\]\cr
#'  A reactive value telling whether any row is selected in a table.
#' 
#' @importFrom glue glue
observe_select_in_table_button <- function(ns, any_row_selected) toggle_state_and_css(
  glue("#{ns('select_in_table')}"),
  "ag-moveselection-button-disabled",
  any_row_selected
)
