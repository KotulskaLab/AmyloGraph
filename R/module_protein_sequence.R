ui_protein_sequence <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("header"), container = h2),
    textOutput(ns("name"), container = strong),
    verbatimTextOutput(ns("sequence")),
    class = "ag-protein-sequence"
  )
}

#' @importFrom purrr pluck
#' @importFrom stringi stri_trans_totitle
server_protein_sequence <- function(id, protein_role, interaction) {
  moduleServer(id, function(input, output, session) {
    output[["header"]] <- glue("{protein_role}:") %>%
      stri_trans_totitle() %>%
      renderText()
    
    observe({
      req(interaction())
      
      output[["name"]] <- interaction() %>%
        pluck(glue("{protein_role}_name")) %>%
        renderText()
      
      output[["sequence"]] <- interaction() %>%
        pluck(glue("{protein_role}_sequence"), 1) %>%
        prettify_chains() %>%
        renderText()
    })
  })
}
