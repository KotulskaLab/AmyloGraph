#' Display single protein panel on selection
#' 
#' @description Displays the panel with details of a single protein when
#' a protein (a node) is selected and hides when not. Moreover, it handles
#' the changes to selected node of a graph.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app.
#' 
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
    toggleCssClass(class = "panel_expanded",
                   condition = is_node_selected(selected_node_id),
                   selector = "#panel_single_protein")
    toggleCssClass(class = "panel_contracted",
                   condition = !is_node_selected(selected_node_id),
                   selector = "#panel_single_protein")
  })
}