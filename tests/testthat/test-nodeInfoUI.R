if(!require(shinytest, quietly = TRUE))
  skip("There is no package 'shinytest' installed!")

if(!shinytest::dependenciesInstalled())
  skip("There are no external dependencies for 'shinytest' installed!")

library(shinytest, quietly = TRUE)

ag_data <- ag_load_data()

skip("cannot locate data")

ui <- ag_ui(ag_data)
server <- ag_server(ag_data) 
app <- shinytest::ShinyDriver$new(shinyApp(ui, server))


test_that("can select ", {
  app$setInputs(`node_info-select_node` = "843a319bed9620e7daba22560e275266")
  expect_match(app$getValue("node_value-info"), "Amyloid beta")
})