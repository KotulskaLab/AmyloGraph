#' @importFrom shinyhelper helper
ui_group_edges <- function(id) {
  ns <- NS(id)
  helper(
    selectInput(
      inputId = ns("group"),
      label = "Group edges by",
      choices = add_none(ag_data_group_labels),
      multiple = FALSE
    ),
    type = "markdown",
    content = "label_group"
  )
}

#' @importFrom purrr when
server_group_edges <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      when(
        input[["group"]],
        . == ag_option("str_null") ~ "",
        ~ .
      )
    })
  })
}
