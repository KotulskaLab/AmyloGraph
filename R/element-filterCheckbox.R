#' @importFrom shinyhelper helper
filterCheckboxInput <- function(id, label_values, pretty_name)
  helper(
    tagAppendAttributes(
      checkboxGroupInput(
        inputId = id,
        label = glue("Filter by \"{pretty_name}\":"),
        choices = label_values,
        selected = label_values
      ),
      class = "filter_checkbox"
    ),
    type = "markdown",
    content = id
  )
