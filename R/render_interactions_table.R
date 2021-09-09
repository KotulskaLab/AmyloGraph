#' @importFrom DT renderDataTable
render_interactions_table <- function(interactions_table)
  renderDataTable(
    interactions_table(),
    options = list(
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All"))
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table())
  )