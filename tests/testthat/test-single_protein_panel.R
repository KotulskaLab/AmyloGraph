if (!require(shinytest, quietly = TRUE))
  skip("There is no package 'shinytest' installed!")

if (!shinytest::dependenciesInstalled())
  skip("There are no external dependencies for 'shinytest' installed!")

library(shinytest, quietly = TRUE)

skip("No idea how to make the code simultaneously read inst/AmyloGraph/ files and work")


withr::with_dir("../../inst/AmyloGraph/", {
  ag_data <- ag_load_data()
  ui <- ag_ui(ag_data)
  server <- ag_server(ag_data)
  app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
  
  test_that("Amyloid proteins has correct number of sources in UniProt", {
    # FapC
    app$setInputs(`single_protein-select_node` = "6a3c09e0b9cdfb2336adf474d763155b")
    expect_match(app$getValue("single_protein-info"), "1 source found in UniProt:")
    # PrP
    app$setInputs(`single_protein-select_node` = "c9b292b95fb4d85e8f8912576301ef48")
    expect_match(app$getValue("single_protein-info"), "3 sources found in UniProt:")
    # IAPP
    app$setInputs(`single_protein-select_node` = "b872ef5d401e16b9b1f28c1ed85c8ee7")
    expect_match(app$getValue("single_protein-info"), "4 sources found in UniProt:")
    # SEVI
    app$setInputs(`single_protein-select_node` = "b33d075178020b90ecb7b1e86cd37e11")
    expect_match(app$getValue("single_protein-info"), "0 sources found in UniProt")
  })
})
