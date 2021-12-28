server_args <- list(
  edge_data = edges, node_data = ag_data[["nodes"]], protein_data = ag_data[["proteins"]]
)

test_that("selected_node_info is empty by default", {
  testServer(server_single_protein, args = server_args, {
    expect_error(selected_node_info())
  })
})

test_that("selected_node_label corresponds to the selected node ID", {
  testServer(server_single_protein, args = server_args, {
    session$setInputs(select_node = "c9b292b95fb4d85e8f8912576301ef48")
    expect_equal(selected_node_label(), "PrP")
  })
})

test_that("protein info contains numbers of UniProt sources", {
  testServer(server_single_protein, args = server_args, {
    # FapC
    session$setInputs(select_node = "6a3c09e0b9cdfb2336adf474d763155b")
    # expect_match(output[["info"]], "1 source found in UniProt:")
    expect_match(output[["info"]], "1 source found:")
    # PrP
    session$setInputs(select_node = "c9b292b95fb4d85e8f8912576301ef48")
    # expect_match(output[["info"]], "3 sources found in UniProt:")
    expect_match(output[["info"]], "3 sources found:")
    # IAPP
    session$setInputs(select_node = "b872ef5d401e16b9b1f28c1ed85c8ee7")
    # expect_match(output[["info"]], "4 sources found in UniProt:")
    expect_match(output[["info"]], "4 sources found:")
    # SEVI
    session$setInputs(select_node = "b33d075178020b90ecb7b1e86cd37e11")
    # expect_match(output[["info"]], "0 sources found in UniProt")
    expect_match(output[["info"]], "0 sources found")
  })
})
