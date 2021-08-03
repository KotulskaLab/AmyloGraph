#' @importFrom shiny renderDataTable
render_interactions_table <- function(interactions_table) renderDataTable(
  interactions_table(),
  options = list(
    scrollY = "calc(100vh - 330px - var(--correction))",
    scrollCollapse = TRUE
  ),
  escape = FALSE
)