elem_app_main_panel <- function(data_nodes)
  fillCol(
    tabsetPanel(
      id = "tabset_panel",
      type = "pills",
      elem_tab_interactions_graph(data_nodes),
      elem_tab_interactions_table(),
      elem_tab_single_interaction(),
      elem_tab_db_statistics(),
      elem_tab_about()
    ),
    id = "main_panel"
  )

elem_tab_interactions_graph <- function(data_nodes)
  tabPanel(
    title = "Graph",
    value = "graph",
    div(
      id = "tab_interactions_graph",
      elem_panel_interactions_graph(),
      elem_panel_single_protein(data_nodes)
    )
  )

#' @importFrom visNetwork visNetworkOutput
elem_panel_interactions_graph <- function()
  div(
    id = "panel_interactions_graph",
    visNetworkOutput("graph", height = "calc(100% - 30px)", width = "100%")
  )

elem_panel_single_protein <- function(data_nodes)
  ui_single_protein("single_protein", data_nodes)

elem_tab_interactions_table <- function()
  tabPanel(
    title = "Table",
    value = "table",
    ui_table(
      "interactions_table",
      BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XLSX")]
    )
  )

elem_tab_single_interaction <- function()
  tabPanel(
    title = "Interaction",
    value = "single_interaction",
    actionButton(
      inputId = "btn_close_tab",
      label = "Close",
      onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', null)")
    ),
    ui_single_interaction("single_interaction")
  )

elem_tab_db_statistics <- function()
  tabPanel(
    title = "Database statistics",
    value = "db_statistics",
    ui_db_statistics("db_statistics")
  )

elem_tab_about <- function()
  tabPanel(
    title = "About",
    value = "about",
    ui_about("about")
  )
