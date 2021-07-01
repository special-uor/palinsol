## code to prepare `BER78` dataset goes here

fpath <- system.file("extdata/INSOL.IN.gz", package = "palinsol")
if (!file.exists(fpath)) {
  print("Downloading file from ...")
}

Table4 <- readr::read_table(fpath, skip = 6, n_max = 19, col_names = FALSE)
Table1 <- readr::read_table(fpath, skip = 25, n_max = 47, col_names = FALSE)
Table5 <- readr::read_table(fpath, skip = 72, n_max = 78, col_names = FALSE)



readr::read_table(fpath,
                  skip = 5)
c("age.ky", "latitude", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

usethis::use_data(BER78, overwrite = TRUE)
