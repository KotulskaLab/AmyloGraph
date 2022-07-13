ui_interaction_doi <- function(id) {
  ns <- NS(id)
  div(
    uiOutput(ns("reference")),
    class = "ag-interaction-doi"
  )
}

server_interaction_doi <- function(id, interaction) {
  moduleServer(id, function(input, output, session) {
    observe({
      req(interaction())
      
      doi <- interaction() %>%
        pluck("doi") %>%
        tolower()
      
      output[["reference"]] <- ag_references() %>%
        filter(doi == doi) %>%
        citify() %>%
        renderMarkdown(text = .) %>%
        HTML() %>%
        renderUI()
    })
  })
}
