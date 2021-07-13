.onLoad <- function(libname, pkgname) {
  prev_options <- options()
  
  new_options <- list(
    ag_str_null = "null" 
  )
  
  unset_inds <- !(names(new_options) %in% names(prev_options))
  if (any(unset_inds)) {
    options(new_options[unset_inds])
  }
  
  invisible()
}