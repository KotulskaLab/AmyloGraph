#' @importFrom shiny NS
ui_db_statistics <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Summary"),
    textOutput(ns("num_publications")),
    textOutput(ns("num_interactions")),
    h3("Interactions by protein"),
    dataTableOutput(ns("num_interactions_by_protein")),
    h3("Interactions by paper"),
    plotOutput(ns("num_interactions_by_paper"))
  )
}

#' @importFrom shiny moduleServer renderText
#' @importFrom glue glue
server_db_statistics <- function(id, interactions, data_nodes) {
  moduleServer(id, function(input, output, session) {
    output[["num_publications"]] <- renderText(
      glue("Number of publications: {length(unique(interactions[['doi']]))}")
    )
    output[["num_interactions"]] <- renderText(
      glue("Number of interactions: {nrow(interactions)}")
    )
    
    output[["num_interactions_by_protein"]] <-
      render_num_interactions_by_protein(interactions, data_nodes)
    
    output[["num_interactions_by_paper"]] <-
      render_num_interactions_by_paper(interactions, height = 440, width = 840)
  })
}
