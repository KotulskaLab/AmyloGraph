reactive_base_data <- function(input, motif) {
  reactive({
    ag_data_interactions %>%
      filter_by_attribute(input, "aggregation_speed") %>%
      filter_by_attribute(input, "elongates_by_attaching") %>%
      filter_by_attribute(input, "heterogenous_fibers") %>%
      filter_by_motif(motif())
  })
}

#' @importFrom dplyr filter
#' @importFrom rlang sym
filter_by_attribute <- function(data, input, attribute_label) {
  data %>%
    filter(!!sym(attribute_label) %in% input[[attribute_label]])
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
