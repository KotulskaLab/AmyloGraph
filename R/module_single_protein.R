#' @importFrom htmltools div
#' @importFrom shinyhelper helper
#' @importFrom shiny selectInput NS uiOutput tabsetPanel tabPanel 
#' @importFrom DT dataTableOutput
#' @importFrom purrr set_names
#' @importFrom glue glue
ui_single_protein <- function(id, node_data) {
  ns <- NS(id)
  div(
    id = "panel_single_protein",
    class = "ag_panel_single_protein",
    elem_select_node(ns("select_node"), node_data),
    elem_info_panel(ns)
  )
}

#' @importFrom shiny moduleServer 
server_single_protein <- function(id, edge_data, node_data) {
  moduleServer(id, function(input, output, session) {
    selected_node_info <- reactive_selected_node_info(input, node_data)
    selected_node_label <- reactive_selected_node_label(selected_node_info)
    
    output[["info"]] <- render_protein_info(input, selected_node_label)
    output[["interactees"]] <- render_interactions_subtable(input, edge_data, from_id, interactee_name)
    output[["interactors"]] <- render_interactions_subtable(input, edge_data, to_id, interactor_name)
  })
}