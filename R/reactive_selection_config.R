#' @importFrom shiny reactive
reactive_selection_config <- function(rvals) {
  reactive({
    if (rvals[["table_visited"]]) {
      list(
        mode = "multiple",
        selected = rvals[["initially_selected"]],
        target = "row"
      )
    } else {
      "multiple"
    }
  })
}
