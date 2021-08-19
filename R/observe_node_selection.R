#' @importFrom shiny observe updateSelectInput NS
#' @importFrom shinyjs toggleCssClass
#' @importFrom visNetwork visNetworkProxy
observe_node_selection <- function(input) {
  observe({
    selected_node_id <- input[[NS("single_protein", "select_node")]]
    visNetworkProxy("graph") %>%
      visToggleNodes(selected_node_id)
    updateSelectInput(
      inputId = NS("single_protein", "select_node"),
      selected = selected_node_id
    )
    toggleCssClass(class = "ag_panel_single_protein_expanded",
                   condition = is_node_selected(selected_node_id),
                   selector = "#panel_single_protein")
  })
}