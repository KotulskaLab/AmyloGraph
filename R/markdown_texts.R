#' @title Format AmyloGraph version into human-friendly string
#' 
#' @description This function retrieves version number of currently installed
#' \pkg{AmyloGraph} package and formats it into a neatly looking sentence.
#' 
#' @return A single string.
#'
#' @importFrom utils packageVersion packageDescription asDateBuilt
markdown_ag_version <- function()
  glue("AmyloGraph version: {packageVersion('AmyloGraph')}. ",
       "Last built: {asDateBuilt(packageDescription('AmyloGraph', fields = 'Built'))}.",
       "\n")

#' @title Access AmyloGraph section as a string
#' 
#' @description This function retrieves a markdown string with a specific
#' section.
#' 
#' @return A single string.
#' 
#' @rdname md-section
markdown_description <- function() {
  "
AmyloGraph is a database of interactions between amyloid proteins. Curators of AmyloGraph manually
gather data from the the published research literature and community data submissions. To learn
more about AmyloGraph, its usage and the process of data curation, visit our
[online manual](https://kotulskalab.github.io/AmyloGraph/)."
}

#' @rdname md-section
markdown_faq <- function() {
  "
## Frequently asked questions

**How can I submit my own data?**

The submission form is [available online](https://forms.gle/7sJCBQdhkCxHdBhD7).

**Why interactions reported in my publications are wrongly annotated?**

We try our best by implementing [a rigorous and transparent two-step data curation procedure](https://kotulskalab.github.io/AmyloGraph/articles/definitions.html#initial-curation), but despite
these measures, we are still prone to errors. Please send an email to
[Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com) with correctly annotated interactions.
Remember to mention their AmyloGraph IDs."
}

#' @rdname md-section
markdown_download <- function() {
  "
  ## Download
  
  Interaction data in AmyloGraph can be downloaded in a [.csv format](https://raw.githubusercontent.com/KotulskaLab/AmyloGraph/main/inst/AmyloGraph/interactions_data.csv). 
  However, you can also use database locally as an R package. For more information, visit [our repository](https://github.com/KotulskaLab/AmyloGraph).

  "
}

#' @rdname md-section
markdown_citation <- function() {
  "
## Citation

Burdukiewicz M, Rafacz D, Barbach A, Hubicka K, Bakala L, Lassota A, Stecko J, Szymanska N,
Wojciechowski J, Kozakiewicz D, Szulc N, Chilimoniuk J, Jeskowiak I, Gasior-Glogowska M,
Kotulska M (2020). AmyloGraph: A comprehensive database of amyloid-amyloid interactions. XXXYYY, doi."
}

#' @rdname md-section
markdown_contact <- function() {
  "
## Contact

For general questions or problems with the data or database, please email
[Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com)."
}

#' @rdname md-section
markdown_acknowledgements <- function() {
  "
## Acknowledgements

AmyloGraph is partially supported by the grant no.
[2019/35/B/NZ2/03997 (National Science Center)](https://projekty.ncn.gov.pl/index.php?projekt_id=459038)
to Małgorzata Kotulska. Access to Wroclaw Centre for Networking and Supercomputing at
Wroclaw University of Science and Technology is greatly acknowledged. We also thank Daniel Otzen
(Aarhus University, Denmark) and Vytautas Smirnovas (University of Vilnus, Lithuania) for fruitful
discussions."
}

#' @rdname md-section
markdown_yttutorial <- function() {
  "
## Video tutorial

To learn more about AmyloGraph, watch our introductory video:"
}

html_yttutorial <- function() {
  tags$iframe(width="560", height="315", src="https://www.youtube.com/embed/3sZ8g7BaDoA", 
              frameborder="0", allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture", 
              allowfullscreen = NA, `data-cookieconsent`="ignore")
}

#' @rdname md-section
markdown_images <- function() {
  "
<img src='vignettes/figures/PWr-eng.png' style='width: 500px'>
<img src='vignettes/figures/WCSS.png' style='width: 500px'>"
}
