#' @importFrom utils packageVersion
markdown_ag_version <- function()
  paste0("AmyloGraph version: ", packageVersion("AmyloGraph"), ".\n")

markdown_description <- function() {
  "
AmyloGraph is a database of interactions between amyloid proteins. Curators of AmyloGraph manually
gather data from the the published research literature and community data submissions. To learn
more about AmyloGraph, its usage and the process of data curation, visit our
[online manual](https://kotulskalab.github.io/AmyloGraph/)."
}

markdown_faq <- function() {
  "
## Frequently asked questions

#### How can I submit my own data?

The submission form is [available online](https://forms.gle/7sJCBQdhkCxHdBhD7).

#### Why interactions reported in my publications are wrongly annotated?

We try our best by implementing [a rigorous and transparent two-step data curation procedure](https://kotulskalab.github.io/AmyloGraph/articles/definitions.html#initial-curation), but despite
these measures, we are still prone to errors. Please send an email to
[Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com) with correctly annotated interactions.
Remember to mention their AmyloGraph IDs."
}

markdown_citation <- function() {
  "
## Citation (coming soon)

Burdukiewicz M, Rafacz D, Barbach A, Hubicka K, Bakala M, Lassota A, Stecko J, Szymanska N,
Wojciechowski J, Kozakiewicz D, Szulc N, Chilimoniuk J, Jeskowiak I, Gasior-Glogowska M,
Kotulska M (2020). AmyloGraph: A comprehensive database of amyloid-amyloid interactions. XXXYYY, doi."
}

markdown_contact <- function() {
  "
## Contact

For general questions or problems with the data or database, please email
[Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com)."
}

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

markdown_images <- function() {
  "
<img src='inst/AmyloGraph/www/PWr-eng.png' style='width: 500px'>
<img src='inst/AmyloGraph/www/WCSS.png' style='width: 500px'>"
}
