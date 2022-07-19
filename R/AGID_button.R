#' Generate AGID buttons
#' 
#' @description Generates a vector of AGID buttons, where AGID codes are labels
#' of the buttons. Each button sets the `selected_interaction` value to the
#' respective AGID on click.
#' 
#' @param interaction_ids \[\code{character()}\]\cr
#'  AGIDs to use for buttons.
#' 
#' @return A `character` vector the same length as `interaction_ids`, each
#' element being a string representation of a button.
#' 
#' @importFrom purrr map2_chr
#' @importFrom stringi stri_rand_strings
AGID_button <- function(interaction_ids) {
  target_input <- NS('single_interaction', 'selected_interaction')
  map2_chr(
    interaction_ids,
    stri_rand_strings(length(interaction_ids), 24),
    ~ as.character(actionButton(
      inputId = .y,
      label = .x,
      onclick = glue("Shiny.setInputValue('{target_input}', '{.x}')")
    ))
  )
}
