#' Builds eoc exercises
#'
#' @param folder_in folder with exercise files to render
#' @param type_doc type of document (from knitr::pandoc_to())
#'
#' @return nothing
#' @export
#'
#' @examples
#' exercises_build(exercises_dir_get(exercises_dir_list()[1]),
#'  type_doc = "html")
exercises_build <- function(folder_in, type_doc) {

  link_eoc_exercises <- links_get()$book_blog_vdr

  files_in <- fs::dir_ls(folder_in)

  my_counter <- 1

  if (is.null(type_doc)) {
    type_doc = 'html'
    #type_doc = 'latex'
  }

  for (i_ex in files_in) {
    l_out <- exercise_to_text(i_ex,
                              my_counter = my_counter,
                              type_doc)

    my_counter <- my_counter + 1
  }

  return(invisible(TRUE))
}

#' exercises -> html
#'
#' @noRd
exercise_to_text <- function(f_in, my_counter, type_doc) {

  # for naming exercises
  my_dir <- file.path(tempdir(),
                      basename(tempfile(pattern = type_doc)))
  dir.create(my_dir)

  #browser()
  # supp_folder <- "~/Desktop/supp"
  # fs::dir_create(supp_folder)

  suppressMessages({
    l_out <- exams::xexams(f_in,
                           driver = list(sweave = list(png = TRUE)),
                           dir = my_dir)

  })

  exercise_text <- paste0(l_out$exam1$exercise1$question, collapse = '\n')
  alternatives <- l_out$exam1$exercise1$questionlist
  correct <- l_out$exam1$exercise1$metainfo$solution
  solution <- paste0(l_out$exam1$exercise1$solution,
                     collapse = '\n')
  ex_type <- l_out$exam1$exercise1$metainfo$type
  supplements <- l_out$exam1$exercise1$supplements

  if (type_doc %in% c('latex', 'epub3')) {

    my_str <- stringr::str_glue(
      '\n\n --- \n\n {sprintf("%02d", my_counter)} - {exercise_text} \n\n '
    )

  } else if (type_doc == 'html') {

    my_str <- paste0('\n\n <hr> \n',
                     #webexercises::total_correct(), '\n',
                     '### Q.', my_counter, '{-} \n',
                     exercise_text)

  }

  cat(my_str)

  return(invisible(TRUE))

}


#' Get dir of exercise
#'
#' @param name_dir name of dir
#'
#' @return full path of dir
#' @export
#'
#' @examples
#' exercises_dir_get(exercises_dir_list()[1])
exercises_dir_get <- function(name_dir) {
  package_dir <- system.file("extdata/eoce",
                             package = "vdr")

  this_path <- fs::path(
    package_dir,
    name_dir
  )

  if (!fs::dir_exists(this_path)) {
    cli::cli_abort("Cant find dir {this_path}")
  }

  return(this_path)
}

#' Lists available eoc dir
#'
#' @param silent be silent?
#' @return a char vector
#' @export
#'
#' @examples
#' exercises_dir_list()
exercises_dir_list <- function(silent = TRUE) {
  package_dir <- system.file("extdata/eoce",
                             package = "vdr")

  available_dirs <- basename(fs::dir_ls(package_dir))

  if (!silent) {
    cli::cli_h3("List of available eoce")

    for (i_dir in available_dirs) {
      cli::cli_alert_info("{i_dir}")
    }
  }

  return(invisible(available_dirs))
}

#' Compiles solution of exercises
#'
#' This function will compile the solution of exercises from the book to
#' a .html file. Aternativelly, all solutiona are available at <www.msperlin.com/vdr>
#'
#' @param dir_output directory where to copy html file (e.g. '~/Desktop')
#' @param run_chunks flag to run code chunks or not. If TRUE, might take a while to process all code.
#'
#' @return path to compiled file
#' @export
#'
#' @examples
#'
#' \dontrun{
#' exercises_compile_solution(dir_output = fs::path_temp())
#' }
exercises_compile_solution <- function(dir_output = "~/vdr-solutions",
                                       run_chunks = TRUE) {
  fs::dir_create(dir_output)

  Sys.setenv(vdr_run_chunks = run_chunks,
             is_eoc_local = TRUE)

  dir_exercises <- exercises_dir_list(TRUE)

  l_exerc <- purrr::map(
    dir_exercises, function(x) fs::dir_ls(exercises_dir_get(x))
  )

  f_exerc <- do.call(c, l_exerc)

  temp_dir <- f_out <- fs::file_temp('eoc-compilation')
  fs::dir_create(temp_dir)

  html_template <-   fs::path(system.file("extdata/templates",
                                          package = "vdr"),
                              "html_template.html")

  cli::cli_alert_info("Compiling solutions (may take a while..)")
  exams::exams2html(f_exerc, n = 1,
                    solution = TRUE,
                    dir = temp_dir,
                    template = html_template)

  # copy files
  f_name <- stringr::str_glue(
    '{format(Sys.time(), "%Y%m%d %H%M%S")}-Solutions-Exercises-VDR.html'
  )

  f_out <- fs::path(dir_output, f_name)


  cli::cli_alert_info("Copying files")
  fs::file_copy(
    fs::dir_ls(temp_dir),
    f_out,
    overwrite = TRUE
  )

  cli::cli_alert_success("Sucess!")

  cli::cli_alert_info("File available at {fs::path_expand(fs::path(dir_output))}")
  cli::cli_alert_info("Search for the file in your file explorer, and open it with your favorite internet browser.")

  return(invisible(f_out))

}
