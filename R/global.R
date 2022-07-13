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
