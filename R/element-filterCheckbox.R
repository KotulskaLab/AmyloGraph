#' @importFrom shinyhelper helper
filterCheckboxInput <- function(id, attribute) {
  label_values <- ag_data_attribute_values[[attribute]]
  helper(
    tagAppendAttributes(
      checkboxGroupInput(
        inputId = id,
        label = glue("Filter by \"{text_label_attribute(attribute)}\":"),
        choices = label_values,
        selected = label_values
      ),
      class = "filter_checkbox"
    ),
    type = "markdown",
    content = attribute
  )
}
