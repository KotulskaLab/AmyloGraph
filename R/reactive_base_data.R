#' Generate base tabular data
#' 
#' @description Applies a set of filters to `ag_data_interactions` based on
#' a set of attribute value filters and motif filter.
#' 
#' @param motif \[\code{reactive(ag_motif(1))}\]\cr
#'  Motif to filter on.
#' @param ... \[\code{reactive(ag_attr_values())}\]\cr
#'  Attribute value filters to apply.
#' 
#' @return A \code{reactive} object with a \code{tibble} containing filtered
#' base tabular data.
#' 
#' @importFrom purrr reduce
reactive_base_data <- function(motif, ...) {
  reactive({
    reduce(
      list(...),
      ~ filter_by_attribute(.x, .y()),
      .init = ag_data_interactions
    ) %>%
      filter_by_motif(motif())
  })
}

#' Filter by an attribute
#' 
#' @description Filters data by attribute answer.
#' 
#' @param data \[\code{tibble()}\]\cr
#'  Data to modify.
#' @param values \[\code{ag_attr_values()}\]\cr
#'  Attribute filter values to keep.
#' 
#' @return A `tibble` with filtered observations.
#' 
#' @importFrom dplyr filter
#' @importFrom rlang sym
filter_by_attribute <- function(data, values) {
  data %>%
    filter(!!sym(attr(values, "attribute", exact = TRUE)) %in% values)
}

#' Filter by motif
#' 
#' @description Filters data on a motif. Either `interactor_sequence` or
#' `interactee_sequence` must contain given motif.
#' 
#' @param data \[\code{tibble()}\]\cr
#'  Data to modify.
#' @param motif \[\code{ag_motif(1)}\]\cr
#'  Motif to filter on.
#' 
#' @return A `tibble` with filtered observations.
#' 
#' @importFrom dplyr filter
filter_by_motif <- function(data, motif) {
  if (is_valid(motif) && nchar(motif) > 0) {
    data %>%
      filter(contains_motif(interactor_sequence, motif) |
               contains_motif(interactee_sequence, motif))
  } else {
    data
  }
}
