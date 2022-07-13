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
    ui_interaction_doi(ns("doi"))
  )
}

#' @importFrom dplyr filter
#' @importFrom purrr pluck
server_single_interaction <- function(id) {
  moduleServer(id, function(input, output, session) {
    interaction <- reactive({
      req(input[["selected_interaction"]])
      
      ag_data_interactions %>%
        filter(AGID == input[["selected_interaction"]])
    })
    
    server_protein_sequence("interactor", interaction)
    server_protein_sequence("interactee", interaction)
    
    server_interaction_property("aggregation_speed", interaction)
    server_interaction_property("elongates_by_attaching", interaction)
    server_interaction_property("heterogenous_fibers", interaction)
    
    server_interaction_doi("doi", interaction)
    
    observe({
      req(interaction())
      
      output[["amylograph_id"]] <- interaction() %>%
        pluck("AGID") %>%
        renderText()
    })
  })
}
