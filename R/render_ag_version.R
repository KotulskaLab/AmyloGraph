render_ag_version <- function() {
  renderText({
    paste0("AmyloGraph version: ", packageVersion("AmyloGraph"), ".\n")
  })
}
