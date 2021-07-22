ag_data <- list(
    ag_data_interactions = AmyloGraph::ag_data_interactions(),
    ag_data_groups = AmyloGraph:::ag_data_groups(),
    ag_data_nodes = AmyloGraph:::ag_data_nodes()
)

ui <- AmyloGraph:::ag_ui(ag_data)
server <- AmyloGraph:::ag_server(ag_data) 

shinyApp(ui = ui, server = server)
