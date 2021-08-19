#' @importFrom shiny NS
ui_interactions_table <- function(id) {
  ns <- NS(id)
  elem_interactions_table(ns("table"))
}

#' @importFrom shiny moduleServer NS
server_interactions_table <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns) 
    
    output[["table"]] <- render_interactions_table(interactions_table)  
  })
}