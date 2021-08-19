#' @importFrom htmltools div img
elem_title_bar <- \(logo_src) div(
  class = "ag_title_bar",
  img(src = logo_src, class = "ag_logo")
)