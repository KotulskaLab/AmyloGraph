#' AmyloGraph interactions list
#' 
#' @return `data.frame` coming from `interactions_data.csv` file with the
#' following changes:
#' * `from_id` and `to_id` are unique hashes of interactor and interactee names,
#' * `interactor_sequence` and `interactee_sequence` are transformed with
#'   \code{\link{read_chains}()} to a vector of tibbles.
#' 
#' @importFrom digest digest
#' @importFrom dplyr mutate
#' @importFrom purrr map_chr map
#' @importFrom readr read_csv
#' @export
ag_data_interactions <- NULL

rlang::on_load({
  ag_data_interactions <- read_csv(
    system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
    col_types = "ccccfffcccccc"
  ) %>%
    mutate(from_id = map_chr(interactor_name, digest),
           to_id = map_chr(interactee_name, digest),
           interactor_sequence = map(interactor_sequence, read_chains),
           interactee_sequence = map(interactee_sequence, read_chains))
})

#' Build list of proteins from interactions list
#' 
#' @return `data.frame` with a list of proteins that interact with others,
#' described with `label` (human-readable name), `id` (machine-readable name),
#' and `shape` (for the purpose of drawing a graph only).
#' 
#' @importFrom digest digest
#' @importFrom dplyr select tibble
#' @importFrom purrr map_chr
ag_data_nodes <- NULL

rlang::on_load({
  ag_data_nodes <- ag_data_interactions %>%
    select(interactor_name, interactee_name) %>% 
    unlist() %>% 
    unique() %>% 
    tibble(label = .,
           id = map_chr(label, digest),
           shape = "box")
})

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
ag_data_groups <- NULL

rlang::on_load({
  ag_data_groups <- {
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
})

#' AmyloGraph proteins list
#' 
#' @return `data.frame` coming from `protein_data.csv` file with the
#' following changes:
#' * `id` contains unique hashes of protein names.
#' 
#' @importFrom digest digest
#' @importFrom dplyr mutate
#' @importFrom purrr map_chr
#' @importFrom readr read_csv
ag_data_proteins <- NULL

rlang::on_load({
  ag_data_proteins <- read_csv(
    system.file("AmyloGraph", "protein_data.csv", package = "AmyloGraph"),
    col_types = "ccc"
  ) %>%
    mutate(id = map_chr(name, digest))
})

#' AmyloGraph references list
#' 
#' @return `data.frame` coming from `reference_table.csv` file with no changes.
#' 
#' @importFrom readr read_csv
#' @export
ag_data_references <- NULL

rlang::on_load({
  ag_data_references <- read_csv(
    system.file("AmyloGraph", "reference_table.csv", package = "AmyloGraph"),
    col_types = "cccccn"
  )
})
