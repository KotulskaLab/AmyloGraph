ifelsePanel <- function(id, condition, content_true, content_false) {
  tagList(
    conditionalPanel(
      id = NS(id, "pos"),
      condition = condition,
      content_true
    ),
    conditionalPanel(
      id = NS(id, "neg"),
      condition = glue("!({condition})"),
      content_false
    )
  )
}