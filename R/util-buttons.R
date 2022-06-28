#' Define a button type
#' 
#' @description Defines a button type with its visible component, server logic,
#' and tags.
#' 
#' @param ui \[\code{function()}\]\cr
#'  Mostly HTML part of a button that's generated during initialization of a
#'  button instance. Must contain \code{ns} parameter.
#' @param server \[\code{function()}\]\cr
#'  Server logic that handles button-related actions. Must contain \code{input}
#'  and \code{output} parameters.
#' @param tags \[\code{character()}\]\cr
#'  Categories to apply to the button type (defined in \code{BUTTON_TAGS}).
#' 
#' @return An \code{ag_button} object.
define_button <- function(ui, server, tags = NULL) {
  structure(
    list(ui = ui, server = server, tags = tags),
    class = "ag_button"
  )
}

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
