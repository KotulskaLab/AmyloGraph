#' @importFrom purrr map exec
ui_button_bar <- function(ns, buttons) {
  exec(div, id = ns("button_bar"), class = "ag-button-bar",
       !!!unname(map(buttons, ~ .x$ui(ns))))
}

#' @importFrom purrr exec walk
server_button_bar <- function(ns, buttons, input, output, ...) {
  args <- list(...)
  any_row_selected <- reactive(!is.null(input[["table_rows_selected"]]))
  
  walk(buttons, ~ exec(.x$server, input, output, !!!args))
  walk(
    BUTTON_TAGS[collect_tags(buttons)],
    ~ .x(ns, ..., any_row_selected = any_row_selected)
  )
}
