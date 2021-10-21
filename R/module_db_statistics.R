#' @importFrom shiny NS
ui_db_statistics <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Summary"),
    textOutput(ns("num_publications")),
    textOutput(ns("num_interactions")),
    h3("Interactions by protein"),
    htmlOutput(ns("num_interactions_by_protein")),
    h3("Interactions by paper"),
    plotOutput(ns("num_interactions_by_paper"))
  )
}

#' @importFrom shiny moduleServer
#' @importFrom glue glue
#' @importFrom purrr map_int
#' @importFrom dplyr bind_cols count
#' @importFrom ggplot2 aes ggplot geom_col scale_x_continuous scale_y_continuous 
#' theme_bw
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
    
    output[["num_interactions_by_paper"]] <- renderPlot(
      ag_data_interactions() %>%
        count(doi) %>%
        count(n, name = "frequency") %>%
        ggplot(aes(x = n, y = frequency)) +
        geom_col() +
        scale_x_continuous("Number of interactions per publication") +
        scale_y_continuous("Number of publications") +
        theme_bw(base_size = 14),
      height = 440,
      width = 840
    )
  })
}