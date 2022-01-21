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
    uiOutput(ns("aggregation_speed")),
    uiOutput(ns("elongates_by_attaching")),
    uiOutput(ns("heterogenous_fibers")),
    h4("Additional info"),
    textOutput(ns("additional_info"))
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
      output[["aggregation_speed"]] <- render_single_interaction_attribute(
        output, selected_interaction, "aggregation_speed",
        "Is the interactor affecting interactee's aggregating speed?"
      )
      output[["elongates_by_attaching"]] <- render_single_interaction_attribute(
        output, selected_interaction, "elongates_by_attaching",
        "If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?"
      )
      output[["heterogenous_fibers"]] <- render_single_interaction_attribute(
        output, selected_interaction, "heterogenous_fibers",
        "Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?"
      )
    })
  })
}

#' @importFrom glue glue
render_single_interaction_attribute <- \(output, selected_interaction, attribute, header) {
  details <- selected_interaction[[glue("{attribute}_details")]]
  output[[attribute]] <- renderUI(
    div(
      h4(header),
      selected_interaction[[attribute]] |>
        as.character() |>
        strong() |>
        p(),
      if (is.na(details)) NULL else p(details)
    )
  )
}