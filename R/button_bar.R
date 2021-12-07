#' @importFrom shiny NS
#' @importFrom htmltools div
#' @importFrom rlang exec
#' @importFrom purrr map
ui_button_bar <- function(ns, buttons) {
  exec(div, id = ns("button_bar"), class = "ag-button-bar",
       !!!unname(map(buttons, ~ .x$ui(ns))))
}

#' @importFrom purrr map walk flatten_chr `%>%`
server_button_bar <- function(ns, buttons, input, output, ...) {
  args <- list(...)
  any_row_selected <- reactive(!is.null(input[["table_rows_selected"]]))
  
  walk(buttons, ~ exec(.x$server, input, output, !!!args))
  map(buttons, ~ .x$tags) %>%
    flatten_chr() %>%
    unique() %>%
    walk(~ BUTTON_TAGS[[.x]](ns, ..., any_row_selected = any_row_selected))
}