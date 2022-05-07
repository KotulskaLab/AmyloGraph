#' Load all AmyloGraph data
#' 
#' @return A list with four elements:
#' * `interactions`: see \code{\link{ag_data_interactions}()}
#' * `groups`: see \code{\link{ag_data_groups}()}
#' * `nodes`: see \code{\link{ag_data_nodes}()}
#' * `proteins`: see \code{\link{ag_data_proteins}()}
ag_load_data <- function()
  list(
    interactions = ag_data_interactions(),
    groups = ag_data_groups(),
    nodes = ag_data_nodes(),
    proteins = ag_data_proteins()
  )

#' Load AmyloGraph interactions list
#' 
#' @return `data.frame` coming from `interactions_data.csv` file with the
#' following changes:
#' * `from_id` and `to_id` are unique hashes of interactor and interactee names,
#' * `interactor_sequence` and `interactee_sequence` are transformed with
#'   \code{\link{read_chains}()} to a vector of tibbles.
#' 
#' @importFrom readr read_csv
#' @importFrom purrr map_chr map
#' @importFrom dplyr `%>%` mutate
#' @importFrom digest digest
#' @export
ag_data_interactions <- function()
  read_csv(system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
           col_types = "ccccfffcccccc") %>%
    mutate(from_id = map_chr(interactor_name, digest),
           to_id = map_chr(interactee_name, digest),
           interactor_sequence = map(interactor_sequence, read_chains),
           interactee_sequence = map(interactee_sequence, read_chains))
  
#' Load AmyloGraph references list
#' 
#' @return `data.frame` coming from `reference_table.csv` file with no changes.
#' 
#' @importFrom readr read_csv
#' @export
ag_references <- function()
  read_csv(system.file("AmyloGraph", "reference_table.csv", package = "AmyloGraph"),
           col_types = "cccccn") 

#' @importFrom dplyr `%>%` select 
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#' @importFrom digest digest
ag_data_nodes <- function()
  ag_data_interactions() %>%
    select(interactor_name, interactee_name) %>% 
    unlist() %>% 
    unique() %>% 
    tibble(label = .,
           id = map_chr(label, digest),
           shape = "box")

#' Load AmyloGraph proteins list
#' 
#' @return `data.frame` coming from `protein_data.csv` file with the
#' following changes:
#' * `id` contains unique hashes of protein names
#' 
#' @importFrom readr read_csv
#' @importFrom dplyr mutate
#' @importFrom purrr map_chr
#' @importFrom digest digest
ag_data_proteins <- function()
  read_csv(system.file("AmyloGraph", "protein_data.csv", package = "AmyloGraph"),
           col_types = "ccc") |>
    mutate(id = map_chr(name, digest))

#' @importFrom purrr set_names map
#' @importFrom tibble tibble tribble
ag_data_groups <- function() {
  groups <- set_names(
    names(ag_option("colnames")),
    ag_option("colnames")
  )[ag_option("interaction_attrs")]
  
  list(
    data = map(
      ag_option("interaction_attrs"),
      ~ tibble(
        values = sort(unique(ag_data_interactions()[[.x]])),
        colors = set_names(ag_option("palette")[seq_along(values)], 
                           values)
      )
    ) |> set_names(ag_option("interaction_attrs")),
    groups = as.list(ag_option("interaction_attrs")) |>
      set_names(tolower(groups))
  )
}

ag_group_labels <- function(data_groups) data_groups[["groups"]]

ag_color_map <- function(data_groups, group) data_groups[["data"]][[group]]