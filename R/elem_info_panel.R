elem_info_panel <- \(ns) ifelsePanel(
  id = ns("ifelse"),
  condition = glue("input.select_node == '{AmyloGraph:::ag_option('str_null')}'"),
  content_true = elem_info_no_node_selected(ns),
  content_false = elem_info_node_selected(ns),
  ns = ns
)

elem_info_no_node_selected <- \(ns) fillCol(
  id = "protein_details",
  "select node to display info about it and interactions associated with it"
)

elem_info_node_selected <- \(ns) fillCol(
  id = "protein_details",
  htmlOutput(ns("info")),
  helper(
    checkboxInput(
      ns("ignore_filters"),
      "Ignore filters in the tables below",
      value = FALSE), 
    content = "ignore_filters"
  ),
  helper(
    actionButton(
      ns("select_in_table"), 
      "Select in interactions table", 
      class = "ag-button"),
    content = "select_in_table"
  ),
  tabsetPanel(
    id = ns("tabs"),
    tabPanel(
      title = "Interactees",
      actionButton(ns("interactees_select_all"), "Select all"),
      actionButton(ns("interactees_deselect_all"), "Deselect all"),
      dataTableOutput(ns("interactees"))),
    tabPanel(
      actionButton(ns("interactors_select_all"), "Select all"),
      actionButton(ns("interactors_deselect_all"), "Deselect all"),
      title = "Interactors",
      dataTableOutput(ns("interactors"))),
    type = "pills"
  ),
  flex = c(2, 1, NA, 9)
)
