edgeTableUI <- function(id) {
  div(
    class = "ag-table-panel",
    dataTableOutput(NS(id, "table"))
  )
}

edgeTableServer <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    output[["table"]] <- renderDataTable(
      edges %>% select(interactor_name,
                       interactee_name,
                       aggregation_speed,
                       elongates_by_attaching,
                       heterogenous_fibers,
                       doi),
      options = list(
        scrollY = "calc(100vh - 330px - var(--correction))",
        scrollCollapse = TRUE
      )
    )
  })
}