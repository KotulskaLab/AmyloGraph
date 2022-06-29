#' Generate AGID buttons
#' 
#' @description Generates a vector of AGID buttons, where AGID codes are labels
#' of the buttons. Each button sets the `selected_interaction` value to the
#' respective AGID on click.
#' 
#' @param interaction_ids \[\code{character()}\]\cr
#'  AGIDs to use for buttons.
#' @param ns \[\code{function(1)}\]\cr
#'  Namespace-generating function that takes single string as the only argument.
#'  This is the namespace buttons should be placed in.
#' 
#' @return A `character` vector the same length as `interaction_ids`, each
#' element being a string representation
#' 
#' @importFrom purrr map_chr
AGID_button <- function(interaction_ids, ns) {
  map_chr(
    interaction_ids,
    function(interaction_id) {
      as.character(actionButton(
        glue("{ns(paste0('interaction_view_selector_', interaction_id))}"),
        as.character(interaction_id),
        onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', '{interaction_id}')")
      ))
    }
  )
}