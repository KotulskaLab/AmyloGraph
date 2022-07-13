#' Load all AmyloGraph data
#' 
#' @return A list with four elements:
#' * `interactions`: see \code{\link{ag_data_interactions}()}
#' * `groups`: see \code{\link{ag_data_groups}()}
#' * `nodes`: see \code{\link{ag_data_nodes}()}
#' * `proteins`: see \code{\link{ag_data_proteins}()}
ag_load_data <- function()
  list(
    groups = ag_data_groups(),
    nodes = ag_data_nodes()
  )

#' Build list of proteins from interactions list
#' 
#' @return `data.frame` with a list of proteins that interact with others,
#' described with `label` (human-readable name), `id` (machine-readable name),
#' and `shape` (for the purpose of drawing a graph only).
#' 
#' @importFrom digest digest
#' @importFrom dplyr select tibble
#' @importFrom purrr map_chr
ag_data_nodes <- function()
  ag_data_interactions %>%
    select(interactor_name, interactee_name) %>% 
    unlist() %>% 
    unique() %>% 
    tibble(label = .,
           id = map_chr(label, digest),
           shape = "box")

#' Build color data for question answers
#' 
#' @return A list with two elements:
#' * `data`: a list of tibbles for each question; each tibble containing two
#'   columns -- `values` (containing answers to questions) and `colors` (with
#'   HTML color codes, all unique within a tibble),
#' * `groups`: a list with translations between human- and computer-friendly
#'   names for questions.
#' 
#' @importFrom dplyr tibble
#' @importFrom purrr set_names map
ag_data_groups <- function() {
  interaction_attrs <- ag_option("interaction_attrs")
  groups <- invert_names(ag_option("colnames"))[interaction_attrs]
  
  list(
    data = map(
      interaction_attrs,
      ~ tibble(
        values = sort(unique(ag_data_interactions[[.x]])),
        colors = set_names(ag_option("palette")[seq_along(values)], values)
      )
    ) %>% set_names(interaction_attrs),
    groups = as.list(interaction_attrs) %>%
      set_names(tolower(groups))
  )
}

ag_group_labels <- function(data_groups) data_groups[["groups"]]

ag_color_map <- function(data_groups, group) data_groups[["data"]][[group]]