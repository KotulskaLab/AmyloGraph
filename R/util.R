#' @importFrom glue glue
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}