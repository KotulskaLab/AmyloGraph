#' @importFrom dplyr filter
#' @importFrom purrr map
#' @importFrom rlang sym expr
reactive_base_data <- function(input, motif) {
  reactive({
    ret <- ag_data_interactions %>%
      filter(!!!map(
        unname(ag_data_group_labels),
        ~ expr(!!sym(.) %in% !!input[[.]]))
      )
    
    if (is_valid(motif()) && nchar(motif()) > 0) {
      ret %>%
        filter(contains_motif(interactor_sequence, motif()) |
                 contains_motif(interactee_sequence, motif()))
    } else {
      ret
    }
  })
}
