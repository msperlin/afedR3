test_df <- function(df) {

  expect_true(nrow(df) > 0)
  expect_true(ncol(df) > 0)

  return(invisible(TRUE))

}

test_data_file <- function(file_in) {
  local_path <- data_path(file_in)

  expect_true(fs::file_exists(local_path))

  ext <- tools::file_ext(local_path)

  if (ext == '.csv') {
    df <- readr::read_csv(local_path)

    flag <- test_df(df)

  }
}

test_that("data functions", {

  available_files <- data_list()

  flags <- lapply(available_files, test_data_file)


})
