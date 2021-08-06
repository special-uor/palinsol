## code to prepare `LA04` dataset goes here
`%>%` <- magrittr::`%>%`
fpath_n <- system.file("extdata/INSOLN.LA2004.BTL.ASC.gz", package = "palinsol")
fpath_p <- system.file("extdata/INSOLP.LA2004.BTL.ASC.gz", package = "palinsol")
if (!file.exists(fpath)) {
  print("Downloading file from ... (broken links)")
}

la04past <- readr::read_table2(fpath_n,
                               col_names = FALSE) %>%
  magrittr::set_names(c("time", "ecc", "eps", "varpi")) %>%
  dplyr::mutate(varpi = (varpi - pi) %% (2 * pi))
la04future <- readr::read_table2(fpath_p,
                               col_names = FALSE) %>%
  magrittr::set_names(c("time", "ecc", "eps", "varpi")) %>%
  dplyr::mutate(varpi = (varpi - pi) %% (2 * pi))

LA04 <- list(
  la04past = la04past,
  la04future = la04future
)

usethis::use_data(LA04, overwrite = TRUE)
