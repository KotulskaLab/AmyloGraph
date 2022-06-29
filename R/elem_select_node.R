elem_select_node <- \(id, node_data) div(
  id = "node_selector_container",
  helper(
  selectInput(
    inputId = id,
    label = "Select node to display info about",
    #null value encoded as text, because NULL value cannot be an element of a vector 
    choices = c(none = ag_option("str_null"),
                label_and_order(node_data[["id"]], node_data[["label"]])),
    multiple = FALSE),
  type = "markdown",
  content = "label_group"
))