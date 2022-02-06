
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AmyloGraph

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/AmyloGraph2)](https://CRAN.R-project.org/package=AmyloGraph2)
[![R-CMD-check](https://github.com/KotulskaLab/AmyloGraph/workflows/R-CMD-check/badge.svg)](https://github.com/KotulskaLab/AmyloGraph/actions)
<!-- badges: end -->

AmyloGraph is a manually curated database on interactions between
amyloid proteins. It is available as an online database
<http://AmyloGraph.com/>, but its functionalities are also accessible as
this R package. The documentation is also [available
online](https://kotulskalab.github.io/AmyloGraph/articles/definitions.html).

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

## Funding

AmyloGraph is partially supported by the grant no. [2019/35/B/NZ2/03997
(National Science
Center)](https://projekty.ncn.gov.pl/index.php?projekt_id=459038) to
Małgorzata Kotulska. Access to Wroclaw Centre for Networking and
Supercomputing at Wroclaw University of Science and Technology is
greatly acknowledged. We also thank Daniel Otzen (Aarhus University,
Denmark) and Vytautas Smirnovas (University of Vilnus, Lithuania) for
fruitful discussions.
