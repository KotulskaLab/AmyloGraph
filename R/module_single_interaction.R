ui_single_interaction <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("amylograph_id"), container = h1),
    ui_protein_sequence(ns("interactor")),
    ui_protein_sequence(ns("interactee")),
    h2("Properties:"),
    ui_protein_property(ns("aggregation_speed")),
    ui_protein_property(ns("elongates_by_attaching")),
    ui_protein_property(ns("heterogenous_fibers")),
    h2("Reference"),
    uiOutput(ns("reference")),
  )
}

#' @importFrom dplyr filter slice
#' @importFrom markdown renderMarkdown
server_single_interaction <- function(id, interactions) {
  moduleServer(id, function(input, output, session) {
    interaction <- reactive({
      req(input[["selected_interaction"]])
      
      interactions %>%
        filter(AGID == input[["selected_interaction"]])
    })
    
    server_protein_sequence("interactor", "interactor", interaction)
    server_protein_sequence("interactee", "interactee", interaction)
    
    server_protein_property("aggregation_speed", "aggregation_speed", interaction)
    server_protein_property("elongates_by_attaching", "elongates_by_attaching", interaction)
    server_protein_property("heterogenous_fibers", "heterogenous_fibers", interaction)
    
    observe({
      req(input[["selected_interaction"]])
      
      reference_data <- ag_references() %>%
        filter(doi == tolower(interaction()[["doi"]]))
      
      output[["amylograph_id"]] <- renderText(interaction()[["AGID"]])
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