# adapted from: https://github.com/DataScienceScotland/shiny_cookies

render_ga <- function() {
  tags$head(includeHTML("./www/ga.html"))
}
