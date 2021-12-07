#' @importFrom shiny NS
#' @importFrom DT dataTableOutput
ui_table <- function(id, buttons, ...) {
  ns <- NS(id)
  tagList(
    ui_button_bar(ns, buttons),
    dataTableOutput(ns("table"), ...)
  )
}
