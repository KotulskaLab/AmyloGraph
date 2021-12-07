#' @importFrom shiny NS
#' @importFrom htmltools div
#' @importFrom rlang exec
#' @importFrom purrr map
ui_button_bar <- function(ns, buttons) {
  exec(div, id = ns("button_bar"), class = "ag-button-bar",
       !!!unname(map(buttons, ~ .x$ui(ns))))
}
