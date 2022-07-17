ui_filter_control <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    ui_group_edges(ns("group_edges")),
    ui_motif_filter(ns("motif")),
    ui_attribute_filter(ns("aggregation_speed"), "aggregation_speed"),
    ui_attribute_filter(ns("elongates_by_attaching"), "elongates_by_attaching"),
    ui_attribute_filter(ns("heterogenous_fibers"), "heterogenous_fibers")
  )
}

server_filter_control <- function(id) {
  moduleServer(id, function(input, output, session) {
    group <- server_group_edges("group_edges")
    motif <- server_motif_filter("motif")
    
    attr_1 <- server_attribute_filter("aggregation_speed", group)
    attr_2 <- server_attribute_filter("elongates_by_attaching", group)
    attr_3 <- server_attribute_filter("heterogenous_fibers", group)
    
    base_data <- reactive_base_data(motif, attr_1, attr_2, attr_3)
    graph_data <- reactive_graph_data(base_data, group)
    
    # TODO: return list of reactives instead and extract them using %<-% or sth
    ret <- reactiveValues(
      table = NULL,
      graph = NULL
    )
    
    observe({
      ret[["table"]] <- base_data()
      ret[["graph"]] <- graph_data()
    })
    
    ret
  })
}
