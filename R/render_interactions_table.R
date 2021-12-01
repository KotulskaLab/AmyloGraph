#' @importFrom DT renderDataTable JS
render_interactions_table <- function(interactions_table, rvals)
  renderDataTable(
    interactions_table(),
    options = list(
      dom = 'lfrtip',
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
    selection = if (ic(rvals[["table_visited"]])) list(mode = "multiple", selected = rvals[["initially_selected"]], target = "row") else "multiple"
  )