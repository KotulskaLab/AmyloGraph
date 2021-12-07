default_table_options <- list(
  dom = 'lfrtip',
  scrollX = TRUE,
  scrollCollapse = TRUE,
  pageLength = 10,
  lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All")),
  # it's either index or header class, and we don't use header classes
  columnDefs = list(list(visible = FALSE, targets = -1))
)

#' @importFrom DT renderDataTable JS
#' @importFrom purrr list_modify
render_table <- function(data, options, ...)
  renderDataTable(
    data(),
    options = list_modify(default_table_options, !!!options),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(data()),
    server = FALSE,
    ...
  )

# Commented out because there's a reactive value that's evaluated too early.
# render_interactions_table <- function(data, rvals) {
#   render_table(
#     data,
#     options = list(
#       scrollY = "calc(100vh - 330px - var(--correction))"
#     ),
#     filter = "top",
#     selection = list(mode = "multiple",
#                      selected = rvals[["initially_selected"]],
#                      target = "row")
#   )
# }

render_interactions_subtable <- function(data, ...) {
  render_table(
    data,
    options = list(
      dom = 'rtip',
      pagingType = "simple"
    )
  )
}

#' @importFrom DT renderDataTable JS
render_interactions_table <- function(data, ..., rvals)
  renderDataTable(
    data(),
    options = list_modify(default_table_options,
                          scrollY = "calc(100vh - 330px - var(--correction))"),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(data()),
    server = FALSE,
    filter = "top",
    selection = list(mode = "multiple",
                     selected = rvals[["initially_selected"]],
                     target = "row")
  )