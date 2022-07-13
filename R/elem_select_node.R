#' @importFrom shinyhelper helper
elem_select_node <- function(id)
  div(
    id = "node_selector_container",
    helper(
      selectInput(
        inputId = id,
        label = "Select node to display info about",
        choices = add_none(label_and_order(
          ag_data_nodes[["id"]], ag_data_nodes[["label"]]
        )),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"
    )
  )