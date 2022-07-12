ui_single_interaction <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("amylograph_id"), container = h1),
    ui_protein_sequence(ns("interactor")),
    ui_protein_sequence(ns("interactee")),
    h2("Properties:"),
    uiOutput(ns("aggregation_speed")),
    uiOutput(ns("elongates_by_attaching")),
    uiOutput(ns("heterogenous_fibers")),
    h2("Reference"),
    uiOutput(ns("reference")),
  )
}

#' @importFrom dplyr filter slice
#' @importFrom markdown renderMarkdown
server_single_interaction <- function(id, interactions) {
  moduleServer(id, function(input, output, session) {
    selected_interaction <- reactive({
      req(input[["selected_interaction"]])
      
      interactions %>%
        filter(AGID == input[["selected_interaction"]])
    })
    
    server_protein_sequence("interactor", "interactor", selected_interaction)
    server_protein_sequence("interactee", "interactee", selected_interaction)
    
    observe({
      req(input[["selected_interaction"]])
      
      reference_data <- ag_references() %>%
        filter(doi == tolower(selected_interaction()[["doi"]]))
      
      output[["amylograph_id"]] <- renderText(selected_interaction()[["AGID"]])
      output[["aggregation_speed"]] <- render_single_interaction_attribute(
        selected_interaction, "aggregation_speed",
        "Is the interactor affecting interactee's aggregating speed?"
      )
      output[["elongates_by_attaching"]] <- render_single_interaction_attribute(
        selected_interaction, "elongates_by_attaching",
        "If interactee is still forming fibrils after the interaction, do fibrils of interactee elongates by attaching to monomers/oligomers/fibrils of interactor?"
      )
      output[["heterogenous_fibers"]] <- render_single_interaction_attribute(
        selected_interaction, "heterogenous_fibers",
        "Is interaction resulting in heterogeneous fibrils consisting of interactor and interactee molecules?"
      )
      output[["reference"]] <- renderUI(HTML(renderMarkdown(text = citify(reference_data))))
    })
  })
}

render_single_interaction_attribute <- function(selected_interaction, attribute, header) {
  # details <- selected_interaction[[glue("{attribute}_details")]]
  renderUI(
    div(
      strong(header),
      p(as.character(selected_interaction()[[attribute]]))
      # The line below allows for displaying comments to answers
      # if (is.na(details)) NULL else p(details)
    )
  )
}