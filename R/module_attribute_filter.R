ui_attribute_filter <- function(id, attribute) {
  ns <- NS(id)
  filterCheckboxInput(
    ns("filter"),
    ag_data_attribute_values[[attribute]],
    text_label_attribute(attribute)
  )
}

server_attribute_filter <- function(id, attribute = id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      structure(
        if (is.null(input[["filter"]])) character() else input[["filter"]],
        attribute = attribute,
        class = "ag_attr_values"
      )
    })
  })
}
