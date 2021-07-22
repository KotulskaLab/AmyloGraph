#' @importFrom htmltools div
#' @importFrom shiny NS dataTableOutput
interactionsTableUI <- function(id) {
  div(
    class = "ag-table-panel",
    dataTableOutput(NS(id, "table"))
  )
}

#' @importFrom shiny moduleServer renderDataTable
#' @importFrom dplyr select `%>%`
interactionsTableServer <- function(id, data_interactions) {
  moduleServer(id, function(input, output, session) {
    output[["table"]] <- renderDataTable(
      data_interactions[["table"]] %>% select(interactor_name,
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