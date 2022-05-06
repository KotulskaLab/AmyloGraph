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
