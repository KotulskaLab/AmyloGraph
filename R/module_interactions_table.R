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
#' @importFrom shinyjs toggleState
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
    
    any_row_selected <- reactive({!is.null(input[["table_rows_selected"]])})
    observe_row_selection(ns, any_row_selected)
    observe({
      toggleState(
        selector = glue("#{ns('table')} .ag-download-button"),
        condition = any_row_selected()
      )
      toggleCssClass(
        class = "ag-download-button-disabled",
        selector = glue("#{ns('table')} .ag-download-button"),
        condition = !any_row_selected()
      )
    })
    
    
    output[["download_csv"]] <- download_handler(input, edges, write_csv, "csv")
    output[["download_xlsx"]] <- download_handler(input, edges, write_xslx, "xlsx")
    
    # must be executed after assignment to the corresponding output
    outputOptions(output, "download_csv", suspendWhenHidden = FALSE)
    outputOptions(output, "download_xlsx", suspendWhenHidden = FALSE)
    
    table_proxy
  })
}