library(shinytest, quietly = TRUE)

ag_data <- list(
  interactions = AmyloGraph::ag_data_interactions(),
  groups = AmyloGraph:::ag_data_groups(),
  nodes = AmyloGraph:::ag_data_nodes()
)

skip("cannot locate data")

ui <- AmyloGraph:::ag_ui(ag_data)
server <- AmyloGraph:::ag_server(ag_data) 
app <- shinytest::ShinyDriver$new(shinyApp(ui, server))


test_that("can select ", {
  app$setInputs(`node_info-select_node` = "843a319bed9620e7daba22560e275266")
  expect_match(app$getValue("node_value-info"), "Amyloid beta")
})