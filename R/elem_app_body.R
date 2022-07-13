elem_app_body <- function()
  fillRow(
    elem_filter_control_panel(),
    elem_app_main_panel(),
    flex = c(ag_option("side_panel_width"), ag_option("main_panel_width"))
  )