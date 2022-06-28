#' Collect button tags
#' 
#' @description This functions collects all unique tags assigned to supplied
#' buttons.
#' 
#' @param buttons \[\code{ag_button()}\]\cr
#'  Buttons whose tags to collect.
#' 
#' @return A vector of tags (a `character` vector).
collect_tags <- function(buttons) {
  lapply(buttons, `[[`, "tags") %>%
    unlist(recursive = TRUE) %>%
    unique()
}
