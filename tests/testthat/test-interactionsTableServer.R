library(shiny, quietly = TRUE)
library(icecream)

edges <- reactiveValues(
  table = NULL,
  graph = NULL,
  node_info = NULL
)

value_1 <- tibble(interactor_name = character(),
                  interactee_name = character(),
                  aggregation_speed = character(),
                  elongates_by_attaching = character(),
                  heterogenous_fibers = character(),
                  doi = character())
value_2 <- tibble(interactor_name = "Interactor Name",
                  interactee_name = "Interactee Name",
                  aggregation_speed = "Aggregation Speed",
                  elongates_by_attaching = "Elongates By Attaching",
                  heterogenous_fibers = "Heterogenous Fibers",
                  doi = "DOI")


test_that("evaluating 'interactions_table' returns an error when 'table' is NULL", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- NULL
    expect_error(interactions_table(), "no applicable method for 'select' applied to an object of class \"NULL\"")
  })
})

test_that("'table' ouput is a list", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- value_1
    session$flushReact()
    expect_type(output[["table"]], "list")
  })
})

test_that("'table' has proper elements", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- value_1
    session$flushReact()
    
    element_names <- names(output[["table"]])
    expected_names <- c("colnames", "action", "options", "evalOptions", "searchDelay", 
                        "callback", "escape")
    expect_setequal(element_names, expected_names)
  })
})

test_that("'table' colnames are correct", {
  shiny::testServer(interactionsTableServer, args = list(edges = edges), {
    edges[["table"]] <- value_1
    session$flushReact()
    
    colnames <- output[["table"]][["colnames"]]
    expected_names <- c("interactor_name", "interactee_name", "aggregation_speed", 
                        "elongates_by_attaching", "heterogenous_fibers", "doi")
    expect_setequal(colnames, expected_names)
  })
})