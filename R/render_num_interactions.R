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
#' @importFrom dplyr mutate arrange select
#' @importFrom DT renderDataTable
#' @importFrom purrr map_int
render_num_interactions_by_protein <- function(nodes) {
  interaction_data <- nodes %>%
    mutate(
      n = map_int(nodes[["id"]], count_interactions),
      n_ors = map_int(nodes[["id"]], count_unique_interactors),
      n_ees = map_int(nodes[["id"]], count_unique_interactees)
    ) %>%
    arrange(label) %>%
    select(label, n, n_ors, n_ees)
  
  renderDataTable(
    interaction_data,
    options = list(
      dom = 't',
      paging = FALSE
    ),
    rownames = FALSE,
    colnames = c("Protein" = "label", "Interaction count" = "n",
                 "Unique interactors" = "n_ors", "Unique interactees" = "n_ees")
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
#' @importFrom dplyr count
#' @importFrom ggplot2 aes ggplot geom_col scale_x_continuous scale_y_continuous 
#' theme_bw
render_num_interactions_by_paper <- function(...) {
  renderPlot({
    ag_data_interactions %>%
      count(doi) %>%
      count(n, name = "frequency") %>%
      ggplot(aes(x = n, y = frequency)) +
      geom_col() +
      scale_x_continuous("Number of interactions per publication") +
      scale_y_continuous("Number of publications") +
      theme_bw(base_size = 14)
  }, ...)
}

#' Count interactions for a protein
#' 
#' @description Counts number of interactions in AmyloGraph database for a given
#' protein.
#' 
#' @param protein_id \[\code{character(1)}\]\cr
#'  ID of protein interactions are counted for.
#' @param interactions \[\code{data.frame()}\]\cr
#'  AmyloGraph interaction data.
#' 
#' @return An `integer` count of interactions.
#' 
#' @importFrom dplyr filter
count_interactions <- function(protein_id) {
  ag_data_interactions %>%
    filter(from_id == protein_id | to_id == protein_id) %>%
    nrow()
}

#' Count unique interacting proteins
#' 
#' @description Counts number of unique interactors/interactees in AmyloGraph
#' database for a given protein.
#' 
#' @param protein_id \[\code{character(1)}\]\cr
#'  ID of protein interactions are counted for.
#' @param interactions \[\code{data.frame()}\]\cr
#'  AmyloGraph interaction data.
#' 
#' @return An `integer` count of distinct protein interacting.
#' 
#' @rdname count-unique-interacts
#' @importFrom dplyr filter pull n_distinct
count_unique_interactors <- function(protein_id) {
  ag_data_interactions %>%
    filter(to_id == protein_id) %>%
    pull(from_id) %>%
    n_distinct()
}

#' @rdname count-unique-interacts
#' @importFrom dplyr filter pull n_distinct
count_unique_interactees <- function(protein_id) {
  ag_data_interactions %>%
    filter(from_id == protein_id) %>%
    pull(to_id) %>%
    n_distinct()
}
