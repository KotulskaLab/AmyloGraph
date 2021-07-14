#' @importFrom purrr map_chr
#' @importFrom dplyr mutate
#' @importFrom digest digest
#' @export
ag_data_interactions <- function()
  read.csv(system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph")) |>
  mutate(from_id = map_chr(interactor_name, digest),
         to_id = map_chr(interactee_name, digest))