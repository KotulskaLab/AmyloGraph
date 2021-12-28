empty_table <- tibble(
  AGID = character(),
  interactor_name = character(),
  interactee_name = character(),
  aggregation_speed = character(),
  elongates_by_attaching = character(),
  heterogenous_fibers = character(),
  doi = character()
)


test_that("evaluating 'interactions_table' returns an error when 'table' is NULL", {
  testServer(server_interactions_table, args = list(
    edges = edges, rvals = rvals
  ), {
    edges[["table"]] <- NULL
    expect_error(interactions_table(), "no applicable method for 'mutate' applied to an object of class \"NULL\"")
  })
})

test_that("'table' output is a json", {
  testServer(server_interactions_table, args = list(
    edges = edges, rvals = rvals
  ), {
    edges[["table"]] <- empty_table
    session$flushReact()
    expect_s3_class(output[["table"]], "json")
  })
})

test_that("there are no rows selected initially", {
  testServer(server_interactions_table, args = list(
    edges = edges, rvals = rvals
  ), {
    expect_false(any_row_selected())
  })
})
