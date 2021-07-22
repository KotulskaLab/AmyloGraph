#' @importFrom shinyhelper helper
#' @importFrom shiny checkboxGroupInput tagAppendAttributes
filterCheckboxInput <- function(id, label_values, pretty_name) {
  helper(
    checkboxGroupInput(
      inputId = id,
      label = glue("Filter by \"{pretty_name}\":"),
      choices = label_values,
      selected = label_values) |>
      tagAppendAttributes(class = "filter_checkbox"),
    type = "markdown",
    content = id)
}