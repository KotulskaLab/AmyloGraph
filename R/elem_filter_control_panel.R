elem_filter_control_panel <- function()
  fillCol(
    img(id = "logo", src = "logo.png"),
    ui_filter_control("filter_control"),
    flex = c(NA, 1),
    id = "filter_control_panel"
  )