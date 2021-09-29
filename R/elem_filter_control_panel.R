elem_filter_control_panel <- \(data_groups) fillCol(
  elem_logo(),
  ui_filter_control("filter_control", data_groups),
  flex = c(NA, 1),
  id = "filter_control_panel"
)