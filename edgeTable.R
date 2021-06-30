edgeTableUI <- function(id) {
  tagList(
    dataTableOutput(NS(id, "table"))
  )
}

edgeTableServer <- function(id, edge_data) {
  moduleServer(id, function(input, output, session) {
    output[["table"]] <- renderDataTable(
      edge_data,
      options = list(
        scrollY = "calc(100vh - 330px - var(--correction))",
        scrollCollapse = TRUE
      )
    )
  })
}