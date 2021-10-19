#' @importFrom shiny NS
ui_db_statistics <- function(id) {
  ns <- NS(id)
  tagList(
    textOutput(ns("num_publications")),
    textOutput(ns("num_interactions"))
  )
}

#' @importFrom shiny moduleServer
#' @importFrom glue glue
server_db_statistics <- function(id, interactions) {
  moduleServer(id, function(input, output, session) {
    output[["num_publications"]] <- renderText(
      glue("Number of publications: {length(unique(interactions[['doi']]))}")
    )
    output[["num_interactions"]] <- renderText(
      glue("Number of interactions: {nrow(interactions)}")
    )
  })
}
