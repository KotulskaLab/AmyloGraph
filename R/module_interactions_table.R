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
#' @importFrom openxlsx write.xlsx
server_interactions_table <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns)
    
    output[["table"]] <- render_interactions_table(interactions_table, ns)
    
    output[["download_csv"]] <- downloadHandler(
      filename = \() "AmyloGraph.csv",
      content = \(file) write.csv(iris, file)
    )
    output[["download_xlsx"]] <- downloadHandler(
      filename = \() "Amylograph.xlsx",
      content = \(file) write.xlsx(iris, file)
    )
  })
}