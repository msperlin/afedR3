#' Format cash
#'
#' @param x a number
#'
#' @return formatted string
#' @export
#'
#' @examples
#' format_cash(10)
format_cash <- function(x, type_cash = 'USD') {

  if (type_cash == 'USD') {
    x_fmt <- scales::dollar(x,
                            prefix = '$',
                            decimal.mark = '.',
                            big.mark = ',',
                            largest_with_cents = Inf)

  }
  if (type_cash == 'BRL') {
    x_fmt <- scales::dollar(x,
                            prefix = 'R$',
                            decimal.mark = ',',
                            big.mark = '.',
                            largest_with_cents = Inf)
  }

  return(x_fmt)
}


#' Formats percentage
#'
#' @param x a number
#'
#' @return formatted string
#' @export
#'
#' @examples
#' format_percent(0.55)
format_percent <- function(x) {

  x_fmt <- scales::percent(x,
                           accuracy = 0.01,
                           decimal.mark = '.',
                           big.mark = ',')

  return(x_fmt)
}

#' Formats date to ISO format (YYYY-MM-DD)
#'
#' This function sounds redundante, but leave it if, in the future, I might change
#' the date format in the book.
#'
#' @param x a date
#'
#' @return formatted date
#' @export
#'
#' @examples
#' format_date("2010-01-01")
format_date <- function(x) {

  x <- as.Date(x)
  x_fmt <- format(x, '%Y-%m-%d')

  return(x_fmt)
}


#' Formats a number (used in plots)
#'
#' @param x a number
#' @param digits number of digits to use
#' @return formatted number (character)
#' @export
#'
#' @examples
#' format_number(1/3)
format_number <- function(x, digits = 4) {

  x <- format(x,
              digits = digits,
              nsmall = 2,
              decimal.mark = ".",
              big.mark = ","
  )

  return(x)
}


#' Produces package citation string
#'
#' Formats package as `pkg` and, when called the first time, adds reference as
#' [@R-pkg]
#'
#' @param pkg a pkg availabe locally or github
#' @param github_address github address of package code (eg. "msperlin/vdr")
#' @param force_ref Logical (TRUE or FALSE) - defines whether to force formal
#' reference (e.g. [@R-pkg])
#' @param make_index Logical (TRUE or FALSE) - defines wheter to write index for
#'  remissive index of book
#'
#' @return a string in rmarkdown
#' @export
#'
#' @examples
#' format_pkg_citation("dplyr")
format_pkg_citation <- function(pkg,
                                github_address = NULL,
                                force_ref = FALSE,
                                make_index = TRUE) {

  installed_pkgs <- utils::installed.packages()[, 1]

  # check if package is installed
  if (!pkg %in% installed_pkgs) {
    cli::cli_alert_info("{pkg} not found, installing it..")

    if (is.null(github_address)) {
      utils::install.packages(pkg)
    } else {
      remotes::install_github(github_address)
    }

  }

  # check engine
  my_engine <- knitr::pandoc_to()

  if (is.null(my_engine)) {
    folder_db_citation <- fs::path_temp("GENERIC--pkg-citations")
  } else {
    folder_db_citation <- fs::path_temp(
      stringr::str_glue("{my_engine}--pkg-citations")
    )
  }

  if (!fs::dir_exists(folder_db_citation)) fs::dir_create(folder_db_citation)
  available_cit <- basename(fs::dir_ls(folder_db_citation))

  if (make_index) {
    str_index <- paste0("\\index{", pkg, "}")
  } else {
    str_index <- ""
  }

  if ((pkg %in% available_cit) && (!force_ref)) {

    pkg_citation <- stringr::str_glue("**{pkg}** {str_index}")

  } else {

    this_cit_file <- fs::path(folder_db_citation, pkg)
    fs::file_touch(this_cit_file)

    pkg_citation <- stringr::str_glue("**{pkg}** {str_index} [@R-{pkg}]")
  }

  return(pkg_citation)

}

#' Produces index string for pkg::function
#'
#' Formats package as `pkg` and, when called the first time, adds reference as
#' [@R-pkg]
#'
#' @param pkg a pkg availabe locally or github
#' @param this_fct name of function
#' @param force_index Logical (TRUE or FALSE) - defines whether to force formal
#' reference (e.g. [@R-pkg])
#' @param force_pkg force citation of package? TRUE|FALSE
#'
#' @return a string in rmarkdown
#' @export
#'
#' @examples
#' format_fct_ref("dplyr", "group_by")
format_fct_ref <- function(pkg,
                           this_fct,
                           force_index = TRUE,
                           force_pkg = FALSE) {

  installed_pkgs <- utils::installed.packages()[, 1]

  # check if package is installed
  if (!pkg %in% installed_pkgs) {
    cli::cli_alert_info("{pkg} not found, installing it..")
    utils::install.packages(pkg)
  }

  # check if function exists
  this_str <- stringr::str_glue("{pkg}::{this_fct}")
  if (!purrr::is_function(eval(parse(text = this_str)))) {
    stop(stringr::str_glue("Cant find function {this_str}"))
  }

  fixed_this_fct <- stringr::str_replace_all(this_fct, stringr::fixed("_"), "\\_")
  str_index <- paste0("\\index{", pkg, "!", fixed_this_fct, "}")

  # check engine
  my_engine <- knitr::pandoc_to()

  if (is.null(my_engine)) {
    dir_temp <- fs::path(fs::path_temp(), "GENERIC--fct-citations")
  } else {
    dir_temp <- fs::path(fs::path_temp(),
                         stringr::str_glue("{my_engine}--fct-citations")
    )
  }


  fs::dir_create(dir_temp)

  # fix name of temp file
  this_str <- this_str |>
    stringr::str_replace_all(pattern = stringr::fixed("::"), "-")

  f_fct <- fs::path(dir_temp, this_str)

  if (!fs::file_exists(f_fct)) {
    fs::file_touch(f_fct)

    str_pkg <- stringr::str_glue(
      "**{pkg}::{this_fct}()**"
    )
  } else {

    if (force_pkg) {
      str_pkg <- stringr::str_glue(
        "**{pkg}::{this_fct}()**"
      )
    } else {
      str_pkg <- stringr::str_glue(
        "**{this_fct}()**"
      )
    }

  }

  if (force_index) {

    fct_citation <- stringr::str_glue("{str_pkg} {str_index}")

  } else {

    fct_citation <- stringr::str_glue("{str_pkg}")

  }

  return(fct_citation)

}

#' Formats a vector of string into readable text
#'
#' @param str_in vector of strings
#'
#' @return a single character object
#' @export
#'
#' @examples
#' format_vec_as_text(c("A", "B", "C"))
format_vec_as_text <- function(str_in) {

  if (length(str_in) < 2) {
    stop("need vector with at least 2 elements")
  }

  len <- length(str_in)
  str_out <- paste0(
    paste0(str_in[1:(len-1)], collapse = ", "),
    " e ",
    str_in[len]
  )

  return(str_out)

}
