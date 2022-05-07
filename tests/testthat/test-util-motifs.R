test_that("correct and incorrect motifs are detected", {
  expect_true(correct_motif("PAIFIGUN*GFO*GFD"))
  expect_true(correct_motif("^HFGJ"))
  expect_true(correct_motif("VTGTEE$"))
  expect_true(correct_motif("^U$"))
  # Empty motif should be considered correct
  expect_true(correct_motif(""))
  
  # Can't use numbers
  expect_false(correct_motif("2762"))
  # Letters must be uppercase
  expect_false(correct_motif("DHRmAG"))
  # No parentheses and other non-letter characters
  expect_false(correct_motif("JMGD(X)GG"))
  # ^ must be first
  expect_false(correct_motif("AIX^GDFD"))
  # And $ must be last
  expect_false(correct_motif("$DOJGFIO"))
  # ^ alone is not enough
  expect_false(correct_motif("^"))
  # Including ^$ without any letters between them
  expect_false(correct_motif("^$"))
})

test_that("motifs are correctly patternized", {
  expect_equal(patternize_motif(""),
               "")
  expect_equal(patternize_motif("PAPLLRIQ"),
               "PAPLLRIQ")
  expect_equal(patternize_motif("AJGKLPS"),
               "A[JIL]GKLPS")
  expect_equal(patternize_motif("^AIX"),
               "^AI[ABCDEFGHIJKLMNOPQRSTUVWXYZ]")
  expect_equal(patternize_motif("^PIZZA$"),
               "^PI[ZEQ][ZEQ]A$")
  expect_equal(patternize_motif("STO*P"),
               "STO.*P")
})

test_that("motifs are correctly detected", {
  sq_tbl <- lapply(
    c("PAUL", "PAULS", "WEOAUIO", "FGIOPW", "SPIOGWX"),
    function(seq) {
      tibble::tibble(
        name = NA,
        sequence = seq
      )
    }
  )
  expect_equal(
    contains_motif(sq_tbl, "AUJ*"),
    c(TRUE, TRUE, TRUE, FALSE, FALSE)
  )
})
