#' @importFrom shiny NS
interactionsTableUI <- function(id) {
  ns <- NS(id)
  elem_interactions_table(ns("table"))
}

#' @importFrom shiny moduleServer
interactionsTableServer <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    interactions_table <- reactive_interactions_table(edges) 
    
    output[["table"]] <- render_interactions_table(interactions_table)  
  })
}