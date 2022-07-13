#' @importFrom shinyjs useShinyjs
ag_ui <- function(ag_data) fillPage(
  useShinyjs(),
  GoogleAnalytics(),
  elem_app_body(),
  theme = "amylograph.css",
  title = "AmyloGraph"
)
