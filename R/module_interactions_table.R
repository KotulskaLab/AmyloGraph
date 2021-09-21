#' @importFrom shiny NS
ui_interactions_table <- function(id) {
  ns <- NS(id)
  tagList(
    downloadButton(ns("download_csv"), "", "ag_hidden_btn"),
    downloadButton(ns("download_xlsx"), "", "ag_hidden_btn"),
    elem_interactions_table(ns("table"))
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom shinyjs hideElement
#' @importFrom readr write_csv
#' @importFrom dplyr `%>%` select
#' @importFrom writexl write_xlsx
server_interactions_table <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns)
    
    output[["table"]] <- render_interactions_table(interactions_table, ns)
    
    output[["download_csv"]] <- downloadHandler(
      filename = \() "AmyloGraph.csv",
      content = \(file) write_csv(
        edges[["table"]] %>% select(-c(from_id, to_id)), file
      )
    )
    output[["download_xlsx"]] <- downloadHandler(
      filename = \() "AmyloGraph.xlsx",
      content = \(file) write_xlsx(
        edges[["table"]] %>% select(-c(from_id, to_id)), file
      )
    )
  })
}