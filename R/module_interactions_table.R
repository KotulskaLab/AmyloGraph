#' @importFrom shiny NS
#' @importFrom shinyjs hidden
ui_interactions_table <- function(id) {
  ns <- NS(id)
  tagList(
    hidden(downloadButton(ns("download_csv"))),
    hidden(downloadButton(ns("download_xlsx"))),
    elem_interactions_table(ns("table"))
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom dplyr `%>%` select slice
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
server_interactions_table <- function(id, edges) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns)
    
    output[["table"]] <- render_interactions_table(
      interactions_table, ns, session
    )
    
    any_record_selected <- reactive({
      !is.null(input[["table_rows_selected"]])
    })
    
    observe({
      toggleState(
        selector = glue("#{ns('table')} .ag-download-button"),
        condition = any_record_selected()
      )
      toggleCssClass(
        class = "ag-download-button-disabled",
        selector = glue("#{ns('table')} .ag-download-button"),
        condition = !any_record_selected()
      )
    })
    
    output[["download_csv"]] <- downloadHandler(
      filename = \() "AmyloGraph.csv",
      content = \(file) write_csv(
        edges[["table"]] %>%
          slice(input[["table_rows_selected"]]) %>%
          select(-c(from_id, to_id)),
        file
      )
    )
    # must be executed after assignment to the corresponding output
    outputOptions(output, "download_csv", suspendWhenHidden = FALSE)
    
    output[["download_xlsx"]] <- downloadHandler(
      filename = \() "AmyloGraph.xlsx",
      content = \(file) write_xlsx(
        edges[["table"]] %>%
          slice(input[["table_rows_selected"]]) %>%
          select(-c(from_id, to_id)),
        file
      )
    )
    # must be executed after assignment to the corresponding output
    outputOptions(output, "download_xlsx", suspendWhenHidden = FALSE)
  })
}