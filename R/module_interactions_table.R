#' @importFrom shiny NS
#' @importFrom shinyjs hidden
ui_interactions_table <- function(id) {
  ns <- NS(id)
  tagList(
    ui_button_bar(
      ns,
      BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XLSX")]
    ),
    dataTableOutput(ns("table"))
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom dplyr `%>%` select slice
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
#' @importFrom shinyjs toggleState
#' @importFrom DT dataTableProxy
server_interactions_table <- function(id, edges, selection_config) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_table_data(edges, ns)
    
    output[["table"]] <- render_interactions_table(
      interactions_table, ns, session, selection_config)
    
    table_proxy <- dataTableProxy("table")
    
    server_button_bar(
      ns,
      BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XLSX")],
      input,
      output,
      table_proxy = table_proxy,
      table_data = reactive(edges[["table"]])
    )
    
    table_proxy
  })
}