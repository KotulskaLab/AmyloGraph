#' @importFrom shinyhelper observe_helpers
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  rvals <- reactiveValues(
    table_visited = FALSE,
    initally_selected = NULL
  )
  
  observeEvent(input[["tabset_panel"]], {
    if (input[["tabset_panel"]] == "table") rvals[["table_visited"]] <- TRUE
  })
  
  edges <- server_filter_control("filter_control", ag_data[["groups"]])
  subtables <- server_single_protein("single_protein", edges)
  # TODO: extract function call below as a separate function that takes
  #  edges and id as only arguments
  table_proxy <- server_table(
    "interactions_table",
    BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XLSX")],
    edges,
    table_data_func = reactive_table_data,
    render_table_func = render_interactions_table,
    selection_config = reactive_selection_config(rvals),
    table_data = reactive(edges[["table"]])
  )
  
  server_single_interaction("single_interaction")
  server_db_statistics("db_statistics")
  server_about("about")
  
  output[["graph"]] <- render_network(edges)
  output[["download_xgmml"]] <- render_XGMML_download("download_xgmml", edges)
  node_positions <- reactive_node_positions(input, "graph")
  output[["download_html"]] <- render_HTML_download("download_html", node_positions)
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
  observe_moving_selection(input, subtables, edges, table_proxy, rvals)
}
