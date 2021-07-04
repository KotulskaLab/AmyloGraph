LabelData <- function(label_groups, label_palette, edge_data) {
  structure(
    list(
      data = map(
        label_groups$id,
        ~ tibble(
          values = sort(unique(edge_data[[.x]])),
          colors = set_names(label_palette[seq_along(values)], values)
        )
      ) %>% set_names(label_groups$id),
      groups = as.list(label_groups$id) %>%
        set_names(label_groups$name)
    ),
    class = "ag_LabelData"
  )
}

ag_groups <- function(x, ...)
  UseMethod("ag_groups")

ag_groups.ag_LabelData <- function(x, ...) {
  x[["groups"]]
}

ag_data <- function(x, group, ...)
  UseMethod("ag_data")

ag_data.ag_LabelData <- function(x, group, ...) {
  x[["data"]][[group]]
}