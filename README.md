
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Palinsol

R package to compute Incoming Solar Radiation (insolation) for
paleoclimate studies. Features three solutions: BER78, BER90 and LA04.
Computes hourly, daily-mean, season-averaged and annual means for all
latitudes.

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/palinsol?color=)](https://cran.r-project.org/package=palinsol)
[![](http://cranlogs.r-pkg.org/badges/last-month/palinsol?color=blue)](https://cran.r-project.org/package=palinsol)
[![](https://img.shields.io/badge/devel%20version-0.97-yellow.svg)](https://github.com/special-uor/palinsol)
[![R build
status](https://github.com/special-uor/palinsol/workflows/R-CMD-check/badge.svg)](https://github.com/special-uor/palinsol/actions)
<!-- badges: end -->

## Installation

You can install the released version of palinsol from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("palinsol")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("special-uor/palinsol")
```

## Example

### Calculation of orbital parameters

The function `astro` can be used to find the orbital paraters. This
function takes three arguments:

  - `t`: time, years after 1950.
  - `solution`: solution used. One of `palinsol::ber78` (Berger, 1978),
    `palinsol::ber90` (Berger and Loutre, 1991) or `palinsol::la04`
    (Laskar, 2004).
  - `degree`: returns angles in degrees if `TRUE`.

For example to find the orbital parameters for the last 100k years with
1k years resolution:

``` r
# Load the pipe operator from `magrittr`
`%>%` <- magrittr::`%>%`

# Create sequence (vector) with years
years <- seq(from = -10^5, to = 0, by = 1000)

# Find orbital parameters
orb_param <- years %>%
  purrr::map_df(palinsol::astro, solution = palinsol::ber78, degree = TRUE)
#> load BER78data

# Append the years to the table with the orbital parameters
orb_param <- orb_param %>%
  dplyr::mutate(year = years, .before = 1)

# Print table with the first 10 rows
orb_param %>%
  dplyr::slice(1:10) %>%
  knitr::kable()
```

|     year |      eps |       ecc |    varpi |      epsp |
| -------: | -------: | --------: | -------: | --------: |
| \-100000 | 23.70902 | 0.0387423 | 178.4873 | 0.3912183 |
|  \-99000 | 23.83934 | 0.0384086 | 194.4552 | 0.3924701 |
|  \-98000 | 23.95612 | 0.0380598 | 210.3612 | 0.3940328 |
|  \-97000 | 24.05717 | 0.0376963 | 226.2127 | 0.3958623 |
|  \-96000 | 24.14078 | 0.0373188 | 242.0180 | 0.3979110 |
|  \-95000 | 24.20567 | 0.0369279 | 257.7851 | 0.4001294 |
|  \-94000 | 24.25103 | 0.0365241 | 273.5225 | 0.4024670 |
|  \-93000 | 24.27642 | 0.0361079 | 289.2382 | 0.4048736 |
|  \-92000 | 24.28181 | 0.0356796 | 304.9401 | 0.4073000 |
|  \-91000 | 24.26751 | 0.0352398 | 320.6358 | 0.4096985 |

Create plots for all the variables

``` r
orb_param %>%
  tidyr::pivot_longer(cols = c(eps, ecc, varpi, epsp),
                      names_to = "var") %>%
  ggplot2::ggplot(ggplot2::aes(year, value)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::facet_wrap(facets = ~var, 
                      scales = "free",
                      labeller = ggplot2::labeller(var = c("ecc" = "Obliquity (ecc)",
                                                           "eps" = "Eccentricity (eps)",
                                                           "varpi" = "True Solar Longitude of the Perihelion (varpi)",
                                                           "epsp" = "(epsp)"))) +
  ggplot2::theme_bw()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
