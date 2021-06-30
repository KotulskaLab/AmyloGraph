edgeTableUI <- function(id) {
  tagList(
    div(
      class = "ag-table-panel",
      dataTableOutput(NS(id, "table")))
  )
}

edgeTableServer <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    output[["table"]] <- renderDataTable(
      edges,
      options = list(
        scrollY = "calc(100vh - 330px - var(--correction))",
        scrollCollapse = TRUE
      )
    )
  })
}