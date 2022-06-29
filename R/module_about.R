ui_about <- function(id) {
  div(
    id = "about",
    markdown(markdown_ag_version()),
    markdown(markdown_description()),
    markdown(markdown_faq()),
    markdown(markdown_citation()),
    markdown(markdown_contact()),
    markdown(markdown_acknowledgements()),
    img(src = "PWr-eng.png", width = "500px"),
    br(),
    img(src = "WCSS.png", width = "500px")
  )
}

server_about <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Yep, it's empty.
  })
}