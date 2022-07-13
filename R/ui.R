#' @importFrom shinyjs useShinyjs
ag_ui <- function() fillPage(
  useShinyjs(),
  GoogleAnalytics(),
  elem_app_body(),
  theme = "amylograph.css",
  title = "AmyloGraph"
)
