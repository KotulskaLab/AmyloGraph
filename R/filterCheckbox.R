filterCheckboxInput <- function(id, label_values, pretty_name) {
  helper(
    checkboxGroupInput(
      inputId = NS(id, "labels_shown"),
      label = glue("Filter by \"{pretty_name}\":"),
      choices = label_values,
      selected = label_values) %>%
      tagAppendAttributes(class = "filter_checkbox"),
    type = "markdown",
    content = id)
}