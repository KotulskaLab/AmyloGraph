ui_attribute_filter <- function(id, attribute) {
  ns <- NS(id)
  filterCheckboxInput(
    ns("filter"),
    ag_data_attribute_values[[attribute]],
    text_label_attribute(attribute)
  )
}

server_attribute_filter <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input[["filter"]]
    })
  })
}
