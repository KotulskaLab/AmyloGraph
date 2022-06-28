#' Render a table of interaction count by protein
#' 
#' @description Renders a table with interaction count for each protein,
#' arranged by protein name alphabetically.
#' 
#' @param interactions \[\code{data.frame()}\]\cr
#'  AmyloGraph interaction data.
#' @param nodes \[\code{data.frame()}\]\cr
#'  AmyloGraph node data.
#' 
#' @importFrom dplyr `%>%` mutate arrange select filter 
#' @importFrom purrr map_int
#' @importFrom DT renderDataTable
render_num_interactions_by_protein <- function(interactions, nodes) {
  interaction_data <- nodes %>%
    mutate(n =  map_int(
      nodes[["id"]],
      \(id) interactions %>%
        filter(from_id == id | to_id == id) %>%
        nrow()
    )) %>%
    arrange(label) %>%
    select(label, n)
  
  renderDataTable(
    interaction_data,
    options = list(
      dom = 't',
      paging = FALSE
    ),
    rownames = FALSE,
    colnames = c("Protein" = "label", "Interaction count" = "n")
  )
}

#' Render a plot of interaction count by paper
#' 
#' @description Renders a barplot of the frequency of interaction counts for
#' papers; this shows how many interactions are usually retrieved from a single
#' paper.
#' 
#' @param interactions \[\code{data.frame()}\]\cr
#'  AmyloGraph interaction data.
#' @param ... \cr
#'  Additional parameters to \code{renderPlot()}.
#' 
#' @importFrom dplyr `%>%` count
#' @importFrom shiny renderPlot
#' @importFrom ggplot2 aes ggplot geom_col scale_x_continuous scale_y_continuous 
#' theme_bw
render_num_interactions_by_paper <- function(interactions, ...) {
  renderPlot({
    interactions %>%
      count(doi) %>%
      count(n, name = "frequency") %>%
      ggplot(aes(x = n, y = frequency)) +
      geom_col() +
      scale_x_continuous("Number of interactions per publication") +
      scale_y_continuous("Number of publications") +
      theme_bw(base_size = 14)
  }, ...)
}
