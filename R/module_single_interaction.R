#' @importFrom shiny NS
ui_single_interaction <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("amylograph_id"), container = h2),
    h2("Interactor:"),
    textOutput(ns("interactor_name")),
    verbatimTextOutput(ns("interactor_sequence")),
    h2("Interactee:"),
    textOutput(ns("interactee_name")),
    verbatimTextOutput(ns("interactee_sequence")),
    h2("Properties:"),
    h4("DOI"),
    uiOutput(ns("doi")),
    h4("Is the interactor affecting interactee's aggregating speed?"),
    textOutput(ns("aggregation_speed")),
    h4("If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?"),
    textOutput(ns("elongates_by_attaching")),
    h4("Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?"),
    textOutput(ns("heterogenous_fibers"))
  )
}

#' @importFrom shiny moduleServer
server_single_interaction <- function(id, interactions) {
  moduleServer(id, function(input, output, session) {
    observe({
      req(input[["selected_interaction"]])
      
      selected_interaction <- interactions %>%
        filter(AGID == input[["selected_interaction"]])
      
      output[["amylograph_id"]] <- renderText(selected_interaction[["AGID"]])
      output[["doi"]] <- renderUI(HTML(linkify_doi(selected_interaction[["doi"]], truncate = FALSE)))
      output[["interactor_name"]] <- renderText(selected_interaction[["interactor_name"]])
      output[["interactor_sequence"]] <- renderText(prettify_sequence_output(selected_interaction[["interactor_sequence"]]))
      output[["interactee_name"]] <- renderText(selected_interaction[["interactee_name"]])
      output[["interactee_sequence"]] <- renderText(prettify_sequence_output(selected_interaction[["interactee_sequence"]]))
      output[["aggregation_speed"]] <- renderText(selected_interaction[["aggregation_speed"]])
      output[["elongates_by_attaching"]] <- renderText(selected_interaction[["elongates_by_attaching"]])
      output[["heterogenous_fibers"]] <- renderText(selected_interaction[["heterogenous_fibers"]])
    })
  })
}