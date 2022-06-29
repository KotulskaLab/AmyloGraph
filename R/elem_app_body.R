elem_app_body <- function(data_nodes, data_groups)
  fillRow(
    elem_filter_control_panel(data_groups),
    elem_app_main_panel(data_nodes),
    flex = c(ag_option("side_panel_width"), ag_option("main_panel_width"))
  )