## code to prepare `BER90` dataset goes here
`%>%` <- magrittr::`%>%`
fpath <- system.file("extdata/BER90.IN.gz", package = "palinsol")
if (!file.exists(fpath)) {
  print("Downloading file from ... (broken link)")
}

tb4 <- readr::read_table2(fpath,
                          skip = 1,
                          n_max = 80,
                          col_names = FALSE) %>%
  magrittr::set_names(c("Term", "Amp", "Rate", "Phase"))
tb1 <- readr::read_table2(fpath,
                          skip = 161,
                          n_max = 1000,
                          col_names = FALSE) %>%
  magrittr::set_names(c('Term', 'Amp', 'Rate', 'Phase', 'Period'))
tb5 <- readr::read_table2(fpath,
                          skip = 6481,
                          n_max = 1000,
                          col_names = FALSE) %>%
  magrittr::set_names(c('Term', 'Amp', 'Rate', 'Phase', 'Period'))

tb2 <- palinsol:::generate_table2(tb1, tb4, tb5, sol = 'BER90')

tb4 <- tb4 %>%
  dplyr::mutate(Term = seq_along(Term),
                Period = 360 * 360 / Rate)

BER90 <- list(
  Table1 = tb1,
  Table2 = tb2,
  Table4 = tb4,
  Table5 = tb5
)

usethis::use_data(BER90, overwrite = TRUE)
