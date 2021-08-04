library(shiny, quietly = TRUE)
library(icecream)

edges <- reactiveValues(
  table = NULL,
  graph = NULL,
  node_info = NULL
)

value_1 <- tibble(AGID = character(),
                  interactor_name = character(),
                  interactee_name = character(),
                  aggregation_speed = character(),
                  elongates_by_attaching = character(),
                  heterogenous_fibers = character(),
                  doi = character())
value_2 <- tibble(AGID = "AGID",
                  interactor_name = "Interactor Name",
                  interactee_name = "Interactee Name",
                  aggregation_speed = "Aggregation Speed",
                  elongates_by_attaching = "Elongates By Attaching",
                  heterogenous_fibers = "Heterogenous Fibers",
                  doi = "DOI")


test_that("evaluating 'interactions_table' returns an error when 'table' is NULL", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- NULL
    expect_error(interactions_table(), "no applicable method for 'mutate' applied to an object of class \"NULL\"")
  })
})

test_that("'table' ouput is 'json'", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- value_1
    session$flushReact()
    expect_s3_class(output[["table"]], "json")
  })
})
