.onLoad <- function(libname, pkgname) {
  prev_options <- options()
  
  new_options <- list(
    ag_str_null = "null", 
    ag_palette = c("#F9564F", "#A4B0F5", "#4F3824", "#00CC66",
                   "#B33F62", "#F3C677", "#0C0A3E", "gray40"),
    ag_side_panel_width = 2
  )
  
  unset_inds <- !(names(new_options) %in% names(prev_options))
  if (any(unset_inds)) {
    options(new_options[unset_inds])
  }
  
  icecream::ic_disable()
  invisible()
}