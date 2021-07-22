ag_data <- list(
    interactions = AmyloGraph::ag_data_interactions(),
    groups = AmyloGraph:::ag_data_groups(),
    nodes = AmyloGraph:::ag_data_nodes()
)

ui <- AmyloGraph:::ag_ui(ag_data)
server <- AmyloGraph:::ag_server(ag_data) 

shinyApp(ui = ui, server = server)
