#' @importFrom shiny NS tagList
#' @importFrom DT dataTableOutput
ui_table <- function(id, buttons, ...) {
  ns <- NS(id)
  tagList(
    ui_button_bar(ns, buttons),
    dataTableOutput(ns("table"), ...)
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom DT dataTableProxy
server_table <- function(id, buttons, edges, table_data_func, render_table_func, ...) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    formatted_table_data <- table_data_func(edges, ns)
    output[["table"]] <- render_table_func(formatted_table_data, ...)
    table_proxy <- dataTableProxy("table")
    
    server_button_bar(ns, buttons, input, output, ...,
                      table_proxy = table_proxy)
    
    table_proxy
  })
}
