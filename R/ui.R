#' @importFrom shinyjs useShinyjs
ag_ui <- function(ag_data) fillPage(
  useShinyjs(),
  GoogleAnalytics(),
  elem_app_body(ag_data[["nodes"]], ag_data[["groups"]]),
  theme = "amylograph.css",
  title = "AmyloGraph"
)
