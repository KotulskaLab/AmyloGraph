test_that("read_chains() returns correct tibble", {
  expect_equal(
    read_chains(">chain 1\nACGGTCAGTCTGGA\n> chain 2\nTTAGTCAGCAGA\nAGGA",
                separator = "\n"),
    tibble::tribble(
      ~name, ~sequence,
      "chain 1", "ACGGTCAGTCTGGA",
      "chain 2", "TTAGTCAGCAGAAGGA"
    )
  )
})
