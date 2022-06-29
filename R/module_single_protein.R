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
      edge_data, NS(ns("interactees")), input, "from_id", "interactee_name")
    subtables[["interactors"]] <- reactive_subtable_data(
      edge_data, NS(ns("interactors")), input, "to_id", "interactor_name")
    
    server_table(
      "interactees",
      BUTTONS[c("SELECT_ALL", "DESELECT_ALL")],
      edge_data,
      table_data_func = function(edges, ns) {
        reactive_subtable_data(edges, ns, input, "from_id", "interactee_name")
      },
      render_table_func = render_interactions_subtable
    )
    
    server_table(
      "interactors",
      BUTTONS[c("SELECT_ALL", "DESELECT_ALL")],
      edge_data,
      table_data_func = function(edges, ns) {
        reactive_subtable_data(edges, ns, input, "to_id", "interactor_name")
      },
      render_table_func = render_interactions_subtable
    )
    
    transfer_selection_allowed <- reactive_allow_selection_transfer(input)
    observe_select_in_table_button(ns, transfer_selection_allowed)
    
    subtables
  })
}