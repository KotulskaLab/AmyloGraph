#' @importFrom shinyjs useShinyjs
#' @importFrom htmltools div img
#' @importFrom shiny sidebarLayout sidebarPanel tabsetPanel tabPanel fillPage fillCol fillRow
#' @importFrom visNetwork visNetworkOutput
ag_ui <- function(ag_data) fillPage(
  useShinyjs(),
  render_ga(),
  elem_app_body(ag_data[["nodes"]], ag_data[["groups"]]),
  theme = "amylograph.css",
  title = "AmyloGraph"
)
