elem_app_body <- \(data_nodes, data_groups) sidebarLayout(
  elem_filter_control_panel(data_groups),
  elem_app_main_panel(data_nodes)
)