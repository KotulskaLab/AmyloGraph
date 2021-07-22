#' @importFrom shinyjs useShinyjs
#' @importFrom htmltools div img
#' @importFrom shiny sidebarLayout sidebarPanel tabsetPanel tabPanel fluidPage
#' @importFrom visNetwork visNetworkOutput
ag_ui <- function(ag_data) fluidPage(
  theme = "amylograph.css",
  useShinyjs(),
  
  div(
    class = "ag-title",
    img(src = "AGT5.png", class = "ag-logo")
  ),
  sidebarLayout(
    sidebarPanel(
      graphControlUI("graph_control", ag_data[["groups"]]),
      width = ag_option("side_panel_width")
    ),
    mainPanel(
      tabsetPanel(
        id = "graph-table-panel",
        tabPanel(
          title = "Graph",
          div(class = "ag-page-content",
              div(class = "ag-graph-panel",
                  visNetworkOutput("graph", height = "calc(100% - 10px)", width = "auto")
              ),
              nodeInfoUI("node_info", ag_data[["nodes"]])
          )
        ),
        tabPanel(
          title = "Table",
          interactionsTableUI("all_edges")
        )
      ),
      width = 12 - ag_option("side_panel_width")
    )
  )
)