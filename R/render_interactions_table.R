#' @importFrom DT renderDataTable
render_interactions_table <- function(interactions_table)
  renderDataTable(
    interactions_table(),
    options = list(
      dom = "lBfrtip",
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      lengthMenu = list(c(10, 25, 50, 100, -1), c("10", "25", "50", "100", "All")),
      buttons = list("colvis", list(
        extend = "collection",
        text = "Download",
        buttons = list(
          list(
            extend = "csv",
            filename = "AmyloGraph"
          ),
          list(
            extend = "excel",
            filename = "AmyloGraph"
          )
        )
      ))
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table()),
    extensions = "Buttons",
    server = FALSE
  )