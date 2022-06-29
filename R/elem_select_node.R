#' @importFrom shinyhelper helper
elem_select_node <- function(id, node_data)
  div(
    id = "node_selector_container",
    helper(
      selectInput(
        inputId = id,
        label = "Select node to display info about",
        choices = add_none(label_and_order(node_data[["id"]], node_data[["label"]])),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"
    )
  )