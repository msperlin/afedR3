#' Copy all book files to local folder
#'
#' This function will grab files from the afedR package and copy all of it to a local folder,
#' separated by directories including R code, data, slides and end-chapter exercises.
#'
#' @param path_to_copy Path to copy all the book files
#'
#' @return TRUE, if sucessful
#' @export
#'
#' @examples
#' bookfiles_get()
bookfiles_get <- function(path_to_copy = '~/afedR-files') {

  if (!dir.exists(path_to_copy)) {

    cli::cli_alert_info('Path {path_to_copy} does not exists and is created.')
    fs::dir_create(path_to_copy, recurse = TRUE)
  }

  # data files
  data_path_files <- get_pkg_dir('data')
  data_path_to_copy <- file.path(path_to_copy, 'data')

  cli::cli_alert_info('Copying data files files to {fs::path_expand(data_path_to_copy)}')

  if (!dir.exists(data_path_to_copy)) dir.create(data_path_to_copy,
                                                 recursive = TRUE)

  files_to_copy <- list.files(data_path_files, full.names = TRUE)

  flag <- file.copy(from = files_to_copy, to = data_path_to_copy,
                    overwrite = TRUE)

  if (all(flag)) cli::cli_alert_success('\t{length(flag)} files copied')

  my_link <- cli::style_hyperlink(fs::path_expand(path_to_copy),
                                  paste0("file://",
                                         fs::path_expand(path_to_copy)))

  # scripts
  data_path_files <- get_pkg_dir('book-scripts')
  data_path_to_copy <- file.path(path_to_copy, 'book-scripts')

  cli::cli_alert_info('Copying book script files to {fs::path_expand(data_path_to_copy)}')

  if (!dir.exists(data_path_to_copy)) dir.create(data_path_to_copy,
                                                 recursive = TRUE)

  files_to_copy <- list.files(data_path_files, full.names = TRUE)

  flag <- file.copy(from = files_to_copy, to = data_path_to_copy,
                    overwrite = TRUE)

  if (all(flag)) cli::cli_alert_success('\t{length(flag)} files copied')

  my_link <- cli::style_hyperlink(fs::path_expand(path_to_copy),
                                  paste0("file://",
                                         fs::path_expand(path_to_copy)))
  cli::cli_alert_info("Files available at {my_link}")

  return(invisible(TRUE))
}

#' Retrieves book strings
#'
#' @return a list
#' @export
#'
#' @examples
#' book_strings_get()
book_strings_get <- function() {

  l_out <- list(
    book_title = "Visualiza\\u00e7\\u00e3o de Dados com o R",
    book_subtitle = "Aplica\\u00e7\\u00f5es para Finan\\u00e7as e Economia",
    publication_years = c(2022),
    publication_names = c("Edi\\u00e7 01"),
    author_name = "Marcelo S. Perlin",
    author_email = "marcelo.perlin@ufrgs.br"
  )

  return(l_out)
}


#' Use color in book text
#'
#' From: https://bookdown.org/yihui/rmarkdown-cookbook/font-color.html
#'
#' @param x A text to be colorized
#' @param color the color (e.g. "red")
#'
#' @return a colorized version of string (html or latex)
#' @export
#'
#' @examples
#' colorize("ABC", "red")
colorize <- function(x, color) {

  if (knitr::is_latex_output()) {

    sprintf("\\textcolor{%s}{%s}", color, x)

  } else if (knitr::is_html_output()) {

    sprintf("<span style='color: %s;'>%s</span>", color,
            x)

  } else {
    x
  }
}
