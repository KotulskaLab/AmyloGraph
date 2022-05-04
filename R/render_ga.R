# adapted from: https://github.com/DataScienceScotland/shiny_cookies

#' @title Add Google Analytics to shiny app
#' 
#' @description Includes `<head>` and `<body>` tags with Google Analytics
#' cookies scripts.
#' 
#' @return A list of tags to place inside a shiny app.
#' 
#' @importFrom shiny tagList tags includeHTML
render_ga <- function() {
  tagList(tags$head(includeHTML("./www/head-ga.html")),
          tags$body(includeHTML("./www/body-ga.html")))
}
