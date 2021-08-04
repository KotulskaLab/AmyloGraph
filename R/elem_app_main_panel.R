elem_app_main_panel <- \(data_nodes) mainPanel(
  tabsetPanel(
    id = "graph-table-panel",
    elem_tab_graph(data_nodes),
    elem_tab_table()
  ),
  width = 12 - ag_option("side_panel_width")
)

elem_tab_graph <- \(data_nodes) tabPanel(
  title = "Graph",
  div(
    id = "page-content",
    class = "ag-page-content",
    elem_graph(),
    elem_protein_view(data_nodes)
  )
)

elem_graph <- \() div(
  class = "ag-graph-panel",
  visNetworkOutput("graph", height = "calc(100% - 10px)", width = "100%")
)

elem_protein_view <- \(data_nodes) nodeInfoUI("node_info", data_nodes)

elem_tab_table <- \() tabPanel(
  title = "Table",
  interactionsTableUI("all_edges")
)