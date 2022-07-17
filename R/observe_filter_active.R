#' Toggle active state of a filter checkbox
#' 
#' @description Sets a filter in an active state if and only if the currently
#' selected group is equal to filter's attribute.
#' 
#' @param group \[\code{reactive(character(1))}\]\cr
#'  Name of a currently selected attribute (if none, empty string).
#' @param attribute \[\code{character(1)}\]\cr
#'  One of interaction attributes, relevant for observed filter.
#' 
#' @importFrom shinyjs toggleCssClass
observe_filter_active <- function(group, attribute) {
  observe({
    toggleCssClass(
      id = "filter",
      class = "filter_checkbox_active",
      condition = group() == attribute
    )
  })
}
