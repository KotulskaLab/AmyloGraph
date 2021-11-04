#' @importFrom DT renderDataTable
#' @importFrom dplyr `%>%` filter arrange select mutate
render_interactions_subtable <- function(interactions_subtable) {
  renderDataTable(
    interactions_subtable(),
    options = list(
      dom = 'Brtip',
      pageLength = 10,
      lengthChange = FALSE
    ),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(interactions_subtable()),
    server = FALSE
  )
}
