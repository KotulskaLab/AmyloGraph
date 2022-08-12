
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AmyloGraph

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/AmyloGraph2)](https://CRAN.R-project.org/package=AmyloGraph2)
[![R-CMD-check](https://github.com/KotulskaLab/AmyloGraph/workflows/R-CMD-check/badge.svg)](https://github.com/KotulskaLab/AmyloGraph/actions)
<!-- badges: end -->

AmyloGraph is a database of interactions between amyloid proteins.
Curators of AmyloGraph manually gather data from the the published
research literature and community data submissions. To learn more about
AmyloGraph, its usage and the process of data curation, visit our
[online manual](https://kotulskalab.github.io/AmyloGraph/).

AmyloGraph is available as an online database <http://AmyloGraph.com/>,
but its functionalities are also accessible as this R package.

## Run AmyloGraph locally

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("KotulskaLab/AmyloGraph")
# then run AmyloGraph using
library(AmyloGraph)
AmyloGraph()
```

## Frequently asked questions

**How can I submit my own data?**

The submission form is [available
online](https://forms.gle/7sJCBQdhkCxHdBhD7).

**Why interactions reported in my publications are wrongly annotated?**

We try our best by implementing [a rigorous and transparent two-step
data curation
procedure](https://kotulskalab.github.io/AmyloGraph/articles/definitions.html#initial-curation),
but despite these measures, we are still prone to errors. Please send an
email to [Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com) with
correctly annotated interactions. Remember to mention their AmyloGraph
IDs.

## Citation

Burdukiewicz M, Rafacz D, Barbach A, Hubicka K, Bakala L, Lassota A,
Stecko J, Szymanska N, Wojciechowski J, Kozakiewicz D, Szulc N,
Chilimoniuk J, Jeskowiak I, Gasior-Glogowska M, Kotulska M (2020).
AmyloGraph: A comprehensive database of amyloid-amyloid interactions.
XXXYYY, doi.

## Contact

For general questions or problems with the data or database, please
email [Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com).

## Acknowledgements

AmyloGraph is partially supported by the grant no. [2019/35/B/NZ2/03997
(National Science
Center)](https://projekty.ncn.gov.pl/index.php?projekt_id=459038) to
Małgorzata Kotulska. Access to Wroclaw Centre for Networking and
Supercomputing at Wroclaw University of Science and Technology is
greatly acknowledged. We also thank Daniel Otzen (Aarhus University,
Denmark) and Vytautas Smirnovas (University of Vilnus, Lithuania) for
fruitful discussions.

<img src='man/figures/PWr-eng.png' style='width: 500px'>
<img src='man/figures/WCSS.png' style='width: 500px'>
