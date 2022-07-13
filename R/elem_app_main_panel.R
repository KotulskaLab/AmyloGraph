elem_app_main_panel <- function()
  fillCol(
    tabsetPanel(
      id = "tabset_panel",
      type = "pills",
      elem_tab_interactions_graph(),
      elem_tab_interactions_table(),
      elem_tab_single_interaction(),
      elem_tab_db_statistics(),
      elem_tab_about()
    ),
    id = "main_panel"
  )

#' @importFrom visNetwork visNetworkOutput
elem_tab_interactions_graph <- function()
  tabPanel(
    title = "Graph",
    value = "graph",
    div(
      id = "tab_interactions_graph",
      visNetworkOutput("graph", height = "calc(100% - 10px)", width = "100%"),
      ui_single_protein("single_protein")
    )
  )

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
