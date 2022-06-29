#' Add Google Analytics to shiny app
#' 
#' @description Includes `<head>` and `<body>` tags with Google Analytics
#' cookies scripts. Adapted from:
#' https://github.com/DataScienceScotland/shiny_cookies.
#' 
#' @return A list of tags to place inside a shiny app.
#' 
#' @importFrom shiny tagList tags includeHTML
GoogleAnalytics <- function() {
  tagList(
    tags$head(includeHTML("./www/head-ga.html")),
    tags$body(includeHTML("./www/body-ga.html"))
  )
}
