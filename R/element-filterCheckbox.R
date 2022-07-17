#' @importFrom shinyhelper helper
filterCheckboxInput <- function(id, attribute) {
  attr_values <- ag_data_attribute_values[[attribute]]
  helper(
    tagAppendAttributes(
      checkboxGroupInput(
        inputId = id,
        label = glue("Filter by \"{text_label_attribute(attribute)}\":"),
        choices = attr_values,
        selected = attr_values
      ),
      class = "filter_checkbox"
    ),
    type = "markdown",
    content = attribute
  )
}
