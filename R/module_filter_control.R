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

#' @importFrom purrr walk
#' @importFrom shinyjs toggleCssClass
server_filter_control <- function(id) {
  moduleServer(id, function(input, output, session) {
    group <- server_group_edges("group_edges")
    motif <- server_motif_filter("motif")
    aggregation_speed <- server_attribute_filter("aggregation_speed")
    elongates_by_attaching <- server_attribute_filter("elongates_by_attaching")
    heterogenous_fibers <- server_attribute_filter("heterogenous_fibers")
    
    # TODO: extract as observer
    observe({
      walk(ag_data_group_labels,
           ~ toggleCssClass(
             id = NS(.x, "filter"),
             class = "filter_checkbox_active",
             condition = group() == .x)
           )
    })
    
    base_data <- reactive_base_data(aggregation_speed, elongates_by_attaching,
                                    heterogenous_fibers, motif)
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
