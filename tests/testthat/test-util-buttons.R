test_that("tags are collected correctly", {
  expect_setequal(
    collect_tags(BUTTONS[c("DOWNLOAD_XSLX", "DESELECT_ALL", "DOWNLOAD_CSV")]),
    c("DOWNLOAD", "DESELECT")
  )
})
