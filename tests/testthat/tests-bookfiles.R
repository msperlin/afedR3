test_that("book files functions", {

  my_dir <- fs::path(tempdir(), 'afedR3-test')
  flag <- afedR3::bookfiles_get(my_dir)

  expect_true(flag)

})
