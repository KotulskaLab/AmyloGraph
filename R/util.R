#' Extract AmyloGraph option
#' 
#' @description This function accesses the current value of a selected
#' AmyloGraph option.
#' 
#' @param option \[\code{character(1)}\]\cr
#'  Option name without leading `"ag-"`.
#' 
#' @details
#' The currently available options are:
#' \itemize{
#'   \item `str_null`
#'   \item `palette`
#'   \item `side_panel_width`
#'   \item `main_panel_width`
#'   \item `colnames`
#'   \item `interaction_attrs`
#'   \item `center_network`
#'   \item `sequence_group_length`
#'   \item `chain_separator`
#' }
#' 
#' @return Option value.
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}

#' Find AmyloGraph column names in data
#' 
#' @description Filters column names of a data frame or matrix which fulfill
#' a custom role in AmyloGraph, like "interactor name".
#' 
#' @param data \[\code{data.frame()}\]\cr
#'  Data, which column names are to be filtered.
#' 
#' @return A string vector with filtered column names.
#' 
#' @importFrom purrr keep
ag_colnames <- function(data) {
  keep(ag_option("colnames"), ~ .x %in% colnames(data))
}

#' Check if node is selected
#' 
#' @description Checks whether `id` contains any data and whether this data is
#' not equal `str_null` AG option.
#' 
#' @param id \[\code{character(0) | character(1)}\]\cr
#'  Node ID to verify.
#' 
#' @return A single logical value.
is_node_selected <- function(id) {
  length(id) != 0 && id != ag_option("str_null")
}

#' Return plural or singular form
#' 
#' @description Returns a plural or singular form depending on whether `value`
#' is equal 1. By default it returns plural suffix "-s" or singular empty
#' suffix.
#' 
#' @param value \[\code{numeric()}\]\cr
#'  Values to check for equality to 1.
#' @param plural \[\code{character(1)}\]\cr
#'  String to return if equality not satisfied.
#' @param singular \[\code{character(1)}\]\cr
#'  String to return if equality satisfied.
#' 
#' @return A vector of plural/singular values of the same length as `value`
#' parameter.
pluralize <- function(value, plural = "s", singular = "") {
  ifelse(value == 1, singular, plural)
}

#' Read JavaScript code from file
#' 
#' @description Reads JS code from `inst/js` folder inside AmyloGraph package.
#' 
#' @param name \[\code{character(1)}\]\cr
#'  File name without .js extension.
#' 
#' @return A single string with JavaScript code extracted from the file.
load_js_code <- function(name) {
  path <- system.file(c("inst", "js", glue("{name}.js")), package = "AmyloGraph")
  paste(readLines(glue("{path}/{name}.js")))
}

#' Label and reorder a vector
#' 
#' @description Sets names to a vector and then reorders it so that names are
#' sorted alphabetically.
#' 
#' @param value \[\code{vector()}\]\cr
#'  Values to label and reorder.
#' @param label \[\code{character()}\]\cr
#'  Names to use when labeling and reordering.
#' 
#' @return Reordered \code{value} vector with names.
label_and_order <- function(value, label) {
  setNames(value, label)[order(label)]
}

#' Swap values and names
#' 
#' @description Swaps values and names of a vector.
#' 
#' @param value \[\code{named vector()}\]\cr
#'  Named vector with elements that should be coercible to a character vector,
#'  preferably strings.
#' 
#' @return A character vector.
invert_names <- function(value) {
  setNames(names(value), value)
}

#' Add NULL to choices
#' 
#' @description Adds string-encoded NULL labeled as "none" to a vector of
#' choices. This is due to NULL not being able to be an element of a vector.
#' 
#' @param choices \[\code{character()}\]\cr
#'  Choices to augment with NULL.
#' 
#' @return A `character` vector with NULL option prepended to `choices`.
add_none <- function(choices) {
  c(none = ag_option("str_null"), choices)
}

#' Execute code if not NULL
#' 
#' @description Checks input value for equality to `NULL` and executes the code
#' only if this equality is not satisfied.
#' 
#' @param value \[\code{any}\]\cr
#'  Value to compare to `NULL`.
#' @param code \[\code{function(1)}\]\cr
#'  Function that takes `value` as first (unnamed) parameter, executed if
#'  `value` is not `NULL`.
#' @param ... \cr
#'  Other parameters passed to `code()`.
#' 
#' @return `NULL` if input is `NULL`, return value of `code()` otherwise.
if_null_else <- function(value, code = identity, ...) {
  if (is.null(value)) NULL else code(value, ...)
}
