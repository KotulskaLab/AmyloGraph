#' @importFrom purrr set_names map
#' @importFrom tibble tibble tribble
ag_data_groups <- function() {
  groups <- tribble(
    ~ id,                     ~ name,
    "aggregation_speed",      "interactee aggregation speed",
    "elongates_by_attaching", "elongates by attaching",
    "heterogenous_fibers",    "heterogenous fibers"
  )
  
  list(
    data = map(
      groups$id,
      ~ tibble(
        values = sort(unique(ag_data_interactions()[[.x]])),
        colors = set_names(getOption("ag_palette")[seq_along(values)], 
                           values)
      )
    ) |> set_names(groups$id),
    groups = as.list(groups$id) |>
      set_names(groups$name)
  )
}

ag_group_labels <- function(data_groups) data_groups[["groups"]]

ag_color_map <- function(data_groups, group) data_groups[["data"]][[group]]