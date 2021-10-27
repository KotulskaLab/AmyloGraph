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
  uiOutput(ns("info")),
  checkboxInput(ns("ignore_filters"),
                "Ignore filters in the tables below",
                value = FALSE),
  tabsetPanel(
    id = ns("tabs"),
    tabPanel(
      title = "Interactees",
      dataTableOutput(ns("interactees"))),
    tabPanel(
      title = "Interactors",
      dataTableOutput(ns("interactors"))),
    type = "pills"
  ),
  flex = c(2, 1, 9)
)
