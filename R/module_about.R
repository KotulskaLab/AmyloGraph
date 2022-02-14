ui_about <- function(id) {
  ns <- NS(id)
  div(
    id = "about",
    textOutput(ns("ag_version")),
    includeMarkdown("manuals/about.md")
  )
}

#' @importFrom shiny moduleServer
server_about <- function(id) {
  moduleServer(id, function(input, output, session) {
    output[["ag_version"]] <- render_ag_version()
  })
}