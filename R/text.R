#' Access human-readable question text
#' 
#' @description Returns a well-formatted question asked when gathering data
#' about interactions.
#' 
#' @param attribute \[\code{character(1)}\]\cr
#'  An internal name of an interaction attribute.
#' 
#' @return A single string with a human-readable question.
text_question_attribute <- function(attribute) {
  switch(
    attribute,
    "aggregation_speed" =
      "Is the interactor affecting interactee's aggregating speed?",
    "elongates_by_attaching" =
      "If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?",
    "heterogenous_fibers" =
      "Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?",
    stop(glue("Unknown attribute '{attribute}', no question found."))
  )
}

#' Access human-readable attribute label
#' 
#' @description Returns a well-formatted label for an interaction attribute.
#' 
#' @param attribute \[\code{character(1)}\]\cr
#'  An internal name of an interaction attribute.
#' 
#' @return A single string with a human-readable label.
text_label_attribute <- function(attribute) {
  switch(
    attribute,
    "aggregation_speed" = "Fibrillization speed",
    "elongates_by_attaching" = "Physical binding",
    "heterogenous_fibers" = "Heterogenous fibers",
    stop(glue("Unknown attribute '{attribute}', no label found."))
  )
}
