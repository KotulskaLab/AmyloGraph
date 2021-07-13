ifelsePanel <- function(id, condition, content_true, content_false,
                        ns = NS(NULL)) {
  tagList(
    conditionalPanel(
      id = NS(id, "pos"),
      condition = condition,
      content_true,
      ns = ns
    ),
    conditionalPanel(
      id = NS(id, "neg"),
      condition = glue("!({condition})"),
      content_false,
      ns = ns
    )
  )
}