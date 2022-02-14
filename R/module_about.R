#' @importFrom shiny markdown includeMarkdown
ui_about <- function(id) {
  ns <- NS(id)
  div(
    id = "about",
    markdown(markdown_ag_version()),
    includeMarkdown("manuals/about.md")
  )
}

#' @importFrom shiny moduleServer
server_about <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Yep, it's empty.
  })
}