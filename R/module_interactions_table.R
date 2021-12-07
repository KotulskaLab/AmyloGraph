#' @importFrom shiny NS
ui_interactions_table <- function(id) {
  ns <- NS(id)
  tagList(
    div(id = ns("button_bar"),
        actionButton(ns("select_all"),
                     label = "Select all",
                     class = "ag-select-all-button"),
        actionButton(ns("deselect_all"),
                     label = "Deselect all",
                     class = "ag-deselect-all-button"),
        downloadButton(ns("download_csv"),
                       label = "Download selected as CSV",
                       class = "ag-download-button"),
        downloadButton(ns("download_xlsx"), 
                       label = "Download selected as Excel",
                       class = "ag-download-button")),
    elem_interactions_table(ns("table"))
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom dplyr `%>%` select slice
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
#' @importFrom shinyjs toggleState
#' @importFrom DT dataTableProxy
server_interactions_table <- function(id, edges, rvals) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns)
    
    output[["table"]] <- render_interactions_table(interactions_table, rvals)
    
    table_proxy <- dataTableProxy("table")
    
    any_row_selected <- reactive({!is.null(input[["table_rows_selected"]])})
    
    observe_download_button(ns, any_row_selected)
    observe_deselect_button(ns, "deselect_all", any_row_selected)
    observe_deselecting_all(input, "deselect_all", table_proxy)
    observe_selecting_all(input, "select_all", table_proxy, "table")
    
    output[["download_csv"]] <- download_handler(input, edges, write_csv, "csv")
    output[["download_xlsx"]] <- download_handler(input, edges, write_xslx, "xlsx")
    
    table_proxy
  })
}