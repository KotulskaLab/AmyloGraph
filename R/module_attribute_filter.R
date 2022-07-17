ui_attribute_filter <- function(id, attribute) {
  ns <- NS(id)
  filterCheckboxInput(ns("filter"), attribute)
}

server_attribute_filter <- function(id, attribute = id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      structure(
        if (is.null(input[["filter"]])) character() else input[["filter"]],
        attribute = attribute,
        class = c("ag_attr_values", "character")
      )
    })
  })
}
