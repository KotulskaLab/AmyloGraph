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
    class = "panel_contracted",
    elem_select_node(ns("select_node"), node_data),
    elem_info_panel(ns)
  )
}

#' @importFrom shiny moduleServer 
server_single_protein <- function(id, edge_data, node_data, protein_data) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    subtables <- reactiveValues(
      interactees = NULL,
      interactors = NULL
    )
    
    selected_node_info <- reactive_selected_node_info(input, node_data)
    selected_node_label <- reactive_selected_node_label(selected_node_info)
    
    output[["info"]] <- render_protein_info(protein_data, selected_node_label)
  
    subtables[["interactees"]] <- reactive_interactions_subtable(
      input, edge_data, from_id, interactee_name, NS(ns("interactees")))
    subtables[["interactors"]] <- reactive_interactions_subtable(
      input, edge_data, to_id, interactor_name, NS(ns("interactors")))
    
    output[["interactees"]] <- render_interactions_subtable(subtables[["interactees"]])
    output[["interactors"]] <- render_interactions_subtable(subtables[["interactors"]])
    
    interactees_proxy <- dataTableProxy("interactees")
    interactors_proxy <- dataTableProxy("interactors")
    
    interactees_any_row_selected <- reactive({!is.null(input[["interactees_rows_selected"]])})
    interactors_any_row_selected <- reactive({!is.null(input[["interactors_rows_selected"]])})
    
    observe_deselect_button(ns, "interactees_deselect_all", interactees_any_row_selected)
    observe_deselect_button(ns, "interactors_deselect_all", interactors_any_row_selected)
    
    observe_deselecting_all(input, "interactees_deselect_all", interactees_proxy)
    observe_deselecting_all(input, "interactors_deselect_all", interactors_proxy)
    
    observe_selecting_all(input, "interactees_select_all", interactees_proxy, subtables[["interactees"]])
    observe_selecting_all(input, "interactors_select_all", interactors_proxy, subtables[["interactors"]])
    
    any_row_selected_and_filters_applied <- reactive_allow_selection_transfer(input)
    
    observe_select_in_table_button(ns, any_row_selected_and_filters_applied)
    
    subtables
  })
}