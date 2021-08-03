#' @importFrom shiny reactive req
#' @importFrom dplyr `%>%` filter
reactive_selected_node_info <- \(input, node_data) reactive({
  req(input[["select_node"]])
  node_data %>%
    filter(id == input[["select_node"]])
})