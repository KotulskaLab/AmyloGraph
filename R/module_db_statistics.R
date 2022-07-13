#' @importFrom DT dataTableOutput
ui_db_statistics <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Summary"),
    textOutput(ns("num_publications")),
    textOutput(ns("num_interactions")),
    h2("Interactions by protein"),
    dataTableOutput(ns("num_interactions_by_protein")),
    h2("Interactions by paper"),
    plotOutput(ns("num_interactions_by_paper"))
  )
}

server_db_statistics <- function(id) {
  moduleServer(id, function(input, output, session) {
    output[["num_publications"]] <- renderText(
      glue("Number of publications: {length(unique(ag_data_interactions[['doi']]))}")
    )
    output[["num_interactions"]] <- renderText(
      glue("Number of interactions: {nrow(ag_data_interactions)}")
    )
    
    output[["num_interactions_by_protein"]] <-
      render_num_interactions_by_protein()
    
    output[["num_interactions_by_paper"]] <-
      render_num_interactions_by_paper(height = 440, width = 840)
  })
}
