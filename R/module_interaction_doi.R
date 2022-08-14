ui_interaction_doi <- function(id) {
  ns <- NS(id)
  div(
    uiOutput(ns("reference")),
    class = "ag-interaction-doi"
  )
}

#' @importFrom dplyr filter
#' @importFrom markdown renderMarkdown
#' @importFrom purrr pluck
server_interaction_doi <- function(id, interaction) {
  moduleServer(id, function(input, output, session) {
    observe({
      req(interaction())
      
      single_doi <- interaction() %>%
        pluck("doi") %>%
        tolower()
      
      ag_data_references %>%
        filter(doi == single_doi) %>% 
        print
      output[["reference"]] <- ag_data_references %>%
        filter(doi == single_doi) %>%
        citify() %>%
        renderMarkdown(text = .) %>%
        HTML() %>%
        renderUI()
    })
  })
}
