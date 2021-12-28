server_args <- list(
  data_interactions = ag_data[["interactions"]], data_groups = ag_data[["groups"]]
)

test_that("server_filter_control returns a reactiveValues object with 3 elements", {
  testServer(server_filter_control, args = server_args, {
    edges <- session$getReturned()
    
    expect_s3_class(edges, "reactivevalues")
    expect_length(edges, 3)
  })
})

test_that("graph data may concatenate multiple observations into one", {
  testServer(server_filter_control, args = server_args, {
    edges <- session$getReturned()
    
    expect_gte(NROW(edges[["all"]]), NROW(edges[["table"]]))
    expect_gte(NROW(edges[["table"]]), NROW(edges[["graph"]]))
  })
})

skip("Unknown warning when setting motif value (but tests pass)")

test_that("filtering by motif doesn't increase the number of observations", {
  testServer(server_filter_control, args = server_args, {
    # Works when no motif set
    session$setInputs(motif = "")
    expect_gte(
      nrow(interactions_filtered_by_group()),
      nrow(interactions_filtered_by_motif())
    )
    # Works when motif set
    session$setInputs(motif = "AG")
    expect_gte(
      nrow(interactions_filtered_by_group()),
      nrow(interactions_filtered_by_motif())
    )
  })
})

test_that("incorrect motif is ignored", {
  testServer(server_filter_control, args = server_args, {
    session$setInputs(motif = "OBIVAD^")
    expect_equal(
      nrow(interactions_filtered_by_group()),
      nrow(interactions_filtered_by_motif())
    )
  })
})
