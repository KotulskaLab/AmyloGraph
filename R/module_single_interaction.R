ui_single_interaction <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("amylograph_id"), container = h1),
    ui_protein_sequence(ns("interactor")),
    ui_protein_sequence(ns("interactee")),
    h2("Properties:"),
    ui_interaction_property(ns("aggregation_speed")),
    ui_interaction_property(ns("elongates_by_attaching")),
    ui_interaction_property(ns("heterogenous_fibers")),
    h2("Reference"),
    uiOutput(ns("reference")),
  )
}

#' @importFrom dplyr filter
#' @importFrom markdown renderMarkdown
server_single_interaction <- function(id, interactions) {
  moduleServer(id, function(input, output, session) {
    interaction <- reactive({
      req(input[["selected_interaction"]])
      
      interactions %>%
        filter(AGID == input[["selected_interaction"]])
    })
    
    server_protein_sequence("interactor", interaction)
    server_protein_sequence("interactee", interaction)
    
    server_interaction_property("aggregation_speed", interaction)
    server_interaction_property("elongates_by_attaching", interaction)
    server_interaction_property("heterogenous_fibers", interaction)
    
    observe({
      req(interaction())
      
      output[["amylograph_id"]] <- renderText(interaction()[["AGID"]])
      
      reference_data <- ag_references() %>%
        filter(doi == tolower(interaction()[["doi"]]))
      output[["reference"]] <- renderUI(HTML(renderMarkdown(text = citify(reference_data))))
    })
  })
}
