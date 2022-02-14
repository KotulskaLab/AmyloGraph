ag_data <- AmyloGraph:::ag_load_data()

ui <- AmyloGraph:::ag_ui(ag_data)
server <- AmyloGraph:::ag_server(ag_data)

shinyApp(ui = ui, server = server)
