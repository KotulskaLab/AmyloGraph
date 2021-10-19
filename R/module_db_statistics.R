#' @importFrom shiny NS
ui_db_statistics <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Summary"),
    textOutput(ns("num_publications")),
    textOutput(ns("num_interactions")),
    h3("Interactions by protein"),
    htmlOutput(ns("num_interactions_by_protein"))
  )
}

#' @importFrom shiny moduleServer
#' @importFrom glue glue
#' @importFrom purrr map_int
server_db_statistics <- function(id, interactions, data_nodes) {
  moduleServer(id, function(input, output, session) {
    output[["num_publications"]] <- renderText(
      glue("Number of publications: {length(unique(interactions[['doi']]))}")
    )
    output[["num_interactions"]] <- renderText(
      glue("Number of interactions: {nrow(interactions)}")
    )
    output[["num_interactions_by_protein"]] <- renderText({
      ret <- bind_cols(data_nodes, n = map_int(
        data_nodes[["id"]],
        \(id) interactions %>%
          filter(from_id == id | to_id == id) %>%
          nrow()
      )) %>%
        arrange(label)
      glue("<b>{ret[['label']]}</b>: {ret[['n']]} ",
           "interaction{pluralize(ret[['n']], 's')}<br>")
    })
  })
}
