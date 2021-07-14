.onLoad <- function(libname, pkgname) {
  prev_options <- options()
  
  new_options <- list(
    ag_str_null = "null", 
    ag_palette = palette("Dark 2")
  )
  
  unset_inds <- !(names(new_options) %in% names(prev_options))
  if (any(unset_inds)) {
    options(new_options[unset_inds])
  }
  
  invisible()
}