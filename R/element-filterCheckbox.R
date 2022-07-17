#' @importFrom shinyhelper helper
filterCheckboxInput <- function(id, attribute) {
  label <- tolower(text_label_attribute(attribute))
  attr_values <- ag_data_attribute_values[[attribute]]
  helper(
    tagAppendAttributes(
      checkboxGroupInput(
        inputId = id,
        label = glue("Filter by \"{label}\":"),
        choices = attr_values,
        selected = attr_values
      ),
      class = "filter_checkbox"
    ),
    type = "markdown",
    content = attribute
  )
}
