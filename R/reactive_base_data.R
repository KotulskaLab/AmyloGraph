reactive_base_data <- function(aggregation_speed, elongates_by_attaching,
                               heterogenous_fibers, motif) {
  reactive({
    ag_data_interactions %>%
      filter_by_attribute(aggregation_speed()) %>%
      filter_by_attribute(elongates_by_attaching()) %>%
      filter_by_attribute(heterogenous_fibers()) %>%
      filter_by_motif(motif())
  })
}

#' @importFrom dplyr filter
#' @importFrom rlang sym
filter_by_attribute <- function(data, values) {
  data %>%
    filter(!!sym(attr(values, "attribute", exact = TRUE)) %in% values)
}

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
