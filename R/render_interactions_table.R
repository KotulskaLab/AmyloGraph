default_table_options <- list(
  dom = 'lfrtip',
  scrollX = TRUE,
  scrollCollapse = TRUE,
  pageLength = 10,
  lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All")),
  # it's either index or header class, and we don't use header classes
  columnDefs = list(list(visible = FALSE, targets = -1))
)

#' @importFrom DT renderDataTable
#' @importFrom purrr list_modify
render_table <- function(data, options, ...,
                         selection_config = reactive("multiple")) {
  renderDataTable(
    data(),
    options = list_modify(default_table_options, !!!options),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(data()),
    server = FALSE,
    selection = selection_config(),
    ...
  )
}

render_interactions_table <- function(data, ..., selection_config) {
  render_table(
    data,
    options = list(
      scrollY = "calc(100vh - 330px - var(--correction))"
    ),
    filter = "top",
    selection_config = selection_config
  )
}

#' @importFrom DT renderDataTable
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
