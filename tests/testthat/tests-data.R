test_that("data functions", {

  available_files <- data_list()

  for (i_file in available_files) {

    path_file <- data_path(i_file)

    expect_true(fs::file_exists(path_file))
  }

})
