# adapted from: https://github.com/DataScienceScotland/shiny_cookies

#' @importFrom shiny tagList tags includeHTML
render_ga <- function() {
  tagList(tags$head(includeHTML("./www/head-ga.html")),
          tags$body(includeHTML("./www/body-ga.html")))
}
