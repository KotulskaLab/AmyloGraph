is_valid <- function(object, ...) {
  UseMethod("is_valid")
}

is_valid.ag_motif <- function(object, ...) {
  attr(object, "correct", exact = TRUE)
}
