#' @importFrom shinyjs useShinyjs
#' @importFrom htmltools div img
#' @importFrom shiny sidebarLayout sidebarPanel tabsetPanel tabPanel fluidPage
#' @importFrom visNetwork visNetworkOutput
ag_ui <- function(ag_data) fluidPage(
  theme = "amylograph.css",
  useShinyjs(),
  
  elem_title_bar("AGT5.png"),
  elem_app_body(ag_data[["nodes"]], ag_data[["groups"]])
)