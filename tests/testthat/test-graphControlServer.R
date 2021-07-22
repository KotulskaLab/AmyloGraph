library(shiny, quietly = TRUE)

ag_data <- list(
  interactions = AmyloGraph::ag_data_interactions(),
  groups = AmyloGraph:::ag_data_groups(),
  nodes = AmyloGraph:::ag_data_nodes()
)

server <- function(id) graphControlServer(id, ag_data[["interactions"]], ag_data[["groups"]])

test_that("graphControlServer returns an object of class 'reactivevalues' of elements", {
  shiny::testServer(server, {
    edges <- session$getReturned()
    
    expect_s3_class(edges, "reactivevalues")
  })
})


test_that("graphControlServer returns an object of correct length", {
  shiny::testServer(server, {
    edges <- session$getReturned()
    
    expect_length(edges, 3)
  })
})

skip("not yet implemented, left as an example")

test_that("graphControlServer returns correct output when set some input", {
  shiny::testServer(server, {
    session$setInputs(data_interactions = tibble())
  })
})

# test_that("output updates when reactive input changes", {
#   x <- reactiveVal()
#   testServer(summaryServer, args = list(var = x), {
#     x(1:10)
#     session$flushReact()
#     expect_equal(range_val(), c(1, 10))
#     expect_equal(output$mean, "5.5")
#     
#     x(10:20)
#     session$flushReact()
#     expect_equal(range_val(), c(10, 20))
#     expect_equal(output$min, "10")
#   }) 
# })