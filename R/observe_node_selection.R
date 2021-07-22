#' @importFrom shiny observe updateSelectInput NS
#' @importFrom visNetwork visNetworkProxy
observe_node_selection <- function(input) {
  observe({
    selected_node_id <- input[[NS("node_info", "select_node")]]
    visNetworkProxy("graph") %>%
      visToggleNodes(selected_node_id)
    updateSelectInput(
      inputId = NS("node_info", "select_node"),
      selected = selected_node_id
    )
  })
}