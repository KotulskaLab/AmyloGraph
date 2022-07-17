ui_attribute_filter <- function(id, attribute) {
  ns <- NS(id)
  filterCheckboxInput(ns("filter"), attribute)
}

server_attribute_filter <- function(id, group, attribute = id) {
  moduleServer(id, function(input, output, session) {
    observe_filter_active(group, attribute)
    
    reactive({
      structure(
        if (is.null(input[["filter"]])) character() else input[["filter"]],
        attribute = attribute,
        class = c("ag_attr_values", "character")
      )
    })
  })
}
