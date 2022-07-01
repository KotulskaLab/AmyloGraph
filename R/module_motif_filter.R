#' @importFrom shinyhelper helper
ui_motif_filter <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(
      outputId = ns("warning_incorrect"),
      class = "ag-motif-incorrect"
    ),
    helper(
      textInput(ns("value"), "Filter by motif", placeholder = "^LXXA"),
      type = "markdown",
      content = "motif"
    )
  )
}

server_motif_filter <- function(id) {
  moduleServer(id, function(input, output, session) {
    motif <- reactive({
      structure(
        input[["value"]],
        correct = correct_motif(input[["value"]]),
        class = c("ag_motif", "character")
      )
    })
    
    output[["warning_incorrect"]] <- renderUI({
      if (is_valid(motif())) HTML("") else HTML("Incorrect motif provided!")
    })
    
    motif
  })
}
