#' @importFrom htmltools div img
elem_title_bar <- \(logo_src) div(
  class = "ag-title-bar",
  img(src = logo_src, class = "ag-logo")
)