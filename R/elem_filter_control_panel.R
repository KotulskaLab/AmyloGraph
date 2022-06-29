elem_filter_control_panel <- function(data_groups)
  fillCol(
    img(id = "logo", src = "logo.png"),
    ui_filter_control("filter_control", data_groups),
    flex = c(NA, 1),
    id = "filter_control_panel"
  )