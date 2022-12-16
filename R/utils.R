#' Returns local dir of pkg
#'
#' @param sub_dir the sub dir to return path
#'
#' @return a path
#' @export
#'
#' @examples
#' get_pkg_dir("data")
get_pkg_dir <- function(sub_dir) {
  my_dir <- fs::path(
    system.file("extdata", package = "afedR3"),
    sub_dir)

  if (!fs::dir_exists(my_dir)) {
    cli::cli_abort("Cant find dir {my_dir}")
  }

  return(my_dir)
}

#' Check if link exists
#'
#' @noRd
check_link <- function(link_in) {

  #cli::cli_alert_info("Checking {link_in}")

  out_get <- list()

  try({
    out_get <- httr::GET(link_in)
  })

  status_code <- out_get$status_code

  flag <- status_code == 200

  return(invisible(flag))
}
