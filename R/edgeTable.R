edgeTableUI <- function(id) {
  div(
    class = "ag-table-panel",
    dataTableOutput(NS(id, "table"))
  )
}

edgeTableServer <- function(id, edge_data) {
  moduleServer(id, function(input, output, session) {
    output[["table"]] <- renderDataTable(
      edge_data()[["table"]] %>% select(interactor_name,
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