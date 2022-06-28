collect_tags <- function(buttons) {
  lapply(buttons, `[[`, "tags") %>%
    unlist(recursive = TRUE) %>%
    unique()
}
