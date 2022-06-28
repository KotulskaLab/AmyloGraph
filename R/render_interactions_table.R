#' @importFrom DT renderDataTable
render_interactions_table <- function(interactions_table, ns, session, selection_config) {
  renderDataTable(
    interactions_table(),
    options = list(
      dom = 'Bfrtip',
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      # it's either index or header class, and we don't use header classes
      columnDefs = list(list(visible = FALSE, targets = -1))
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table()),
    server = FALSE,
    selection = selection_config()
  )
}

#' @importFrom DT renderDataTable
#' @importFrom dplyr `%>%` filter arrange select mutate
render_interactions_subtable <- function(interactions_subtable) {
  renderDataTable(
    interactions_subtable(),
    options = list(
      dom = 'rtip',
      pageLength = 10,
      pagingType = "simple",
      lengthChange = FALSE,
      # it's either index or header class, and we don't use header classes
      columnDefs = list(list(visible = FALSE, targets = -1))
    ),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(interactions_subtable()),
    server = FALSE
  )
}
