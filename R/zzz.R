.onLoad <- function(libname, pkgname) {
  prev_options <- options()
  
  new_options <- list(
    ag_str_null = "null", 
    ag_palette = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A",
                   "#66A61E", "#E6AB02", "#A6761D", "gray40"),
    ag_side_panel_width = 2
  )
  
  unset_inds <- !(names(new_options) %in% names(prev_options))
  if (any(unset_inds)) {
    options(new_options[unset_inds])
  }
  
  icecream::ic_disable()
  invisible()
}