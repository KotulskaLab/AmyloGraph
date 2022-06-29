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
    
    output[["info"]] <- reactive_selected_node_info(input, node_data) %>%
      reactive_selected_node_label() %>%
      render_protein_info(protein_data)
  
    subtables[["interactees"]] <- reactive_subtable_data(
      edge_data, NS(ns("interactees")), input, from_id, interactee_name)
    subtables[["interactors"]] <- reactive_subtable_data(
      edge_data, NS(ns("interactors")), input, to_id, interactor_name)
    
    output[["interactees-table"]] <- render_interactions_subtable(subtables[["interactees"]])
    output[["interactors-table"]] <- render_interactions_subtable(subtables[["interactors"]])
    
    interactees_proxy <- dataTableProxy("interactees-table")
    interactors_proxy <- dataTableProxy("interactors-table")
    
    interactees_any_row_selected <- reactive({!is.null(input[["interactees-table_rows_selected"]])})
    interactors_any_row_selected <- reactive({!is.null(input[["interactors-table_rows_selected"]])})
    
    observe_deselect_button(ns, "interactees-deselect_all", interactees_any_row_selected)
    observe_deselect_button(ns, "interactors-deselect_all", interactors_any_row_selected)
    
    observe_deselecting_all(input, "interactees-deselect_all", interactees_proxy)
    observe_deselecting_all(input, "interactors-deselect_all", interactors_proxy)
    
    observe_selecting_all(input, "interactees-select_all", interactees_proxy, "interactees-table")
    observe_selecting_all(input, "interactors-select_all", interactors_proxy, "interactors-table")
    
    transfer_selection_allowed <- reactive_allow_selection_transfer(input)
    
    observe_select_in_table_button(ns, transfer_selection_allowed)
    
    subtables
  })
}