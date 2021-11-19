# adapted from: https://github.com/DataScienceScotland/shiny_cookies

render_ga <- function() {
  tagList(HTML("<script src='https://cc.cdn.civiccomputing.com/8/cookieControl-8.x.min.js'></script>"),
          HTML("<script async src='https://www.googletagmanager.com/gtag/js?id=G-0WVLM2F4MJ'></script>"),
          tags$script(src = "cookie_control_config.js")
  )
}
