#' Load all AmyloGraph data
#' 
#' @return A list with four elements:
#' * `interactions`: see \code{\link{ag_data_interactions}()}
#' * `groups`: see \code{\link{ag_data_groups}()}
#' * `nodes`: see \code{\link{ag_data_nodes}()}
#' * `proteins`: see \code{\link{ag_data_proteins}()}
ag_load_data <- function()
  list()

ag_group_labels <- function() ag_data_groups[["groups"]]

ag_color_map <- function(group) ag_data_groups[["data"]][[group]]