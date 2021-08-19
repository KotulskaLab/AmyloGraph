elem_filter_control_panel <- \(data_groups) sidebarPanel(
  ui_filter_control("filter_control", data_groups),
  width = ag_option("side_panel_width")
)