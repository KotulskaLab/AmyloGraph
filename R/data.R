ag_load_data <- \()
  list(
    interactions = AmyloGraph::ag_data_interactions(),
    groups = AmyloGraph:::ag_data_groups(),
    nodes = AmyloGraph:::ag_data_nodes(),
    proteins = AmyloGraph:::ag_data_proteins()
  )

#' @importFrom readr read_csv
#' @importFrom purrr map_chr
#' @importFrom dplyr mutate
#' @importFrom digest digest
#' @export
ag_data_interactions <- \()
  read_csv(system.file("AmyloGraph", "interactions_data.csv", package = "AmyloGraph"),
           col_types = "ccccfffcccccc") |>
    mutate(from_id = map_chr(interactor_name, digest),
           to_id = map_chr(interactee_name, digest))
  
#' @importFrom readr read_csv
#' @export
ag_references <- \()
  read_csv(system.file("AmyloGraph", "reference_table.csv", package = "AmyloGraph"),
           col_types = "cccccn") 

#' @importFrom dplyr `%>%` select 
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#' @importFrom digest digest
ag_data_nodes <- \()
  ag_data_interactions() %>%
    select(interactor_name, interactee_name) %>% 
    unlist() %>% 
    unique() %>% 
    tibble(label = .,
           id = map_chr(label, digest),
           shape = "box")

#' @importFrom readr read_csv
#' @importFrom dplyr mutate
#' @importFrom purrr map_chr
#' @importFrom digest digest
ag_data_proteins <- \()
  read_csv(system.file("AmyloGraph", "protein_data.csv", package = "AmyloGraph"),
           col_types = "ccc") |>
    mutate(id = map_chr(name, digest))

#' @importFrom purrr set_names map
#' @importFrom tibble tibble tribble
ag_data_groups <- \() {
  groups <- tribble(
    ~ id,                     ~ name,
    "aggregation_speed",      "fibrillization speed",
    "elongates_by_attaching", "physical binding",
    "heterogenous_fibers",    "heterogenous fibers"
  )
  
  list(
    data = map(
      groups$id,
      ~ tibble(
        values = sort(unique(ag_data_interactions()[[.x]])),
        colors = set_names(ag_option("palette")[seq_along(values)], 
                           values)
      )
    ) |> set_names(groups$id),
    groups = as.list(groups$id) |>
      set_names(groups$name)
  )
}

ag_group_labels <- \(data_groups) data_groups[["groups"]]

ag_color_map <- \(data_groups, group) data_groups[["data"]][[group]]