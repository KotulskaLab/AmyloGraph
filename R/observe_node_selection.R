#' @importFrom shiny observe updateSelectInput NS
#' @importFrom shinyjs toggleCssClass
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
    toggleCssClass(class = "ag-node-panel-activated",
                   condition = !is_node_selected(selected_node_id),
                   selector = "#page-content > *")
  })
}