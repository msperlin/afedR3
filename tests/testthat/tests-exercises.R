test_that("eoce compilation", {

  # dir list
  dir_list <- exercises_dir_list()

  # dir get
  for (i_dir in dir_list) {
    this_dir <- exercises_dir_get(i_dir)

    cli::cli_alert_info("testing {i_dir}")
    flag <- exercises_build(this_dir, type_doc = "latex",
                            print_eoce = FALSE)

    expect_true(flag)
  }


  # exercises compilation to html
  # DOESNT WORK: "match.call(definition = sys.function(i), call = sys.call(i))`: invalid 'definition' argument"
  #temp_path <- fs::file_temp("testthat-vdr-exercises-")

  # exercises_compile_solution(dir_output = temp_path)
  # n_files <- length(
  #   fs::dir_ls(temp_path)
  # )
  # expect_true(n_files == 1)

  # dir_eoc <- get_pkg_dir("eoce")
  # f_ex <- fs::dir_ls(dir_eoc,
  #                    recurse = TRUE,
  #                    type = 'file')
  #
  # l_xexam = lapply(f_ex, exams::xexams)
  #
  # expect_true(length(f_ex) == length(l_xexam))

})


