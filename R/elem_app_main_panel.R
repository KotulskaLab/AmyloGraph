elem_app_main_panel <- \(data_nodes) mainPanel(
  tabsetPanel(
    id = "app_main_panel",
    type = "pills",
    elem_tab_interactions_graph(data_nodes),
    elem_tab_interactions_table(),
    elem_tab_single_interaction(),
    elem_tab_about()
  ),
  width = 12 - ag_option("side_panel_width")
)

elem_tab_interactions_graph <- \(data_nodes) tabPanel(
  title = "Graph",
  value = "graph",
  div(
    id = "tab_interactions_graph",
    class = "ag_tab_interactions_graph",
    elem_panel_interactions_graph(),
    elem_panel_single_protein(data_nodes)
  )
)

elem_panel_interactions_graph <- \() div(
  class = "ag_panel_interactions_graph",
  visNetworkOutput("graph", height = "calc(100% - 10px)", width = "100%")
)

elem_panel_single_protein <- \(data_nodes) ui_single_protein("single_protein", data_nodes)

elem_tab_interactions_table <- \() tabPanel(
  title = "Table",
  ui_interactions_table("interactions_table")
)

#' @importFrom glue glue
elem_tab_single_interaction <- \() tabPanel(
  title = "Interaction",
  value = "single_interaction",
  actionButton(
    "close_interaction", "Close",
    class = "ag_close_button",
    onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', null)")
  ),
  ui_single_interaction("single_interaction")
)

elem_tab_about <- \() tabPanel(
  title = "About",
  includeMarkdown("manuals/about.md")
)
