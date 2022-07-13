ui_protein_property <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("question"), container = strong),
    textOutput(ns("answer")),
    class = "ag-protein-property"
  )
}

#' @importFrom purrr pluck
server_protein_property <- function(id, interaction, attribute = id) {
  moduleServer(id, function(input, output, session) {
    output[["question"]] <- text_question_attribute(attribute) %>%
      renderText()
    
    observe({
      req(interaction())
      
      output[["answer"]] <- interaction() %>%
        pluck(attribute) %>%
        as.character() %>%
        renderText()
    })
  })
}
