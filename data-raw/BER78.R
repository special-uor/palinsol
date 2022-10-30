## code to prepare `BER78` dataset goes here
`%>%` <- magrittr::`%>%`
source("data-raw/utils-raw-data.R") # import the function generate_table2
fpath <- system.file("extdata/INSOL.IN.gz", package = "palinsol")
if (!file.exists(fpath)) {
  print("Downloading file from ... (broken link)")
}

tb4 <- readr::read_table2(fpath,
                          skip = 6,
                          n_max = 19,
                          col_names = FALSE) %>%
  magrittr::set_names(c("Term", "Amp", "Rate", "Phase", "X5", "X6")) %>%
  dplyr::select(-c(5:6))
tb1 <- readr::read_table2(fpath,
                          skip = 25,
                          n_max = 47,
                          col_names = FALSE) %>%
  dplyr::select(-6) %>%
  magrittr::set_names(c('Term', 'Amp', 'Rate', 'Phase', 'Period'))
tb5 <- readr::read_table2(fpath,
                          skip = 72,
                          n_max = 78,
                          col_names = FALSE) %>%
  dplyr::select(-6) %>%
  magrittr::set_names(c('Term', 'Amp', 'Rate', 'Phase', 'Period'))

tb2 <- generate_table2(tb1, tb4, tb5, sol = 'BER78')

tb4 <- tb4 %>%
  dplyr::mutate(Term = seq_along(Term),
                Period = 360 * 360 / Rate)

BER78 <- list(
  Table1 = tb1,
  Table2 = tb2,
  Table4 = tb4,
  Table5 = tb5
)

usethis::use_data(BER78, overwrite = TRUE, compress = "xz")

