#' List available datasets with description
#'
#' This function will list all available datasets from the book.
#' It also includes a description and origin, if applicable.
#'
#' @param be_silent Be silent?
#'
#' @return A dataframe with the data information
#' @export
#'
#' @examples
#' data_list()
data_list <- function(be_silent = TRUE) {

  path_data <- system.file('extdata/data', package = 'vdr')

  my_files <- list.files(path_data)

  if (!be_silent) {
    cli::cli_h1("Available data files at {fs::path_expand(path_data)}")

    for (i_file in my_files) {
      cli::cli_alert_info("{i_file}")
    }

    message('')
    cli::cli_alert_success("\n\nYou can read files using vdr::data_import(name_of_file)")
    cli::cli_alert_success("Example: df <- vdr::data_import('{sample(my_files, 1)}')")

  }

  return(invisible(my_files))
}

#' Get path to data file
#'
#' This is a helper function of book "Analyzing Financial and Economic Data with R" by Marcelo S. Perlin.
#' With this function you'll be able to read the tables used in the book using only the filenames.
#'
#' @param name_dataset Name of the dataset filename (see \link{data_list} for more details)
#'
#' @return A path to the data file
#' @export
#'
#' @examples
#' file_name <- data_list()[1]
#' path_to_file <- data_path(file_name)
#' path_to_file
data_path <- function(name_dataset) {

  #if (!(name_dataset %in% df_available$file_name)) {
    #stop('Cant find name ', name_dataset, ' in list of available tables.')
  #}

  path_out <- system.file(paste0('extdata/data/', name_dataset),
                          package = 'vdr')

  if (path_out == '') {
    stop('Cant find name ', name_dataset, ' in list of available tables.')
  }

  return(path_out)
}

#' Import data from package vdr
#'
#' This is a helper function of book "Visualização de dados com o R" by Marcelo S. Perlin.
#' With this function you'll be able to read the tables used in the book using only file names.
#'
#' @param name_dataset Name of the dataset filename (see \link{data_list} for more details)
#'
#' @return A path to the data file
#' @export
#'
#' @examples
#' file_name <- data_list()[1]
#' df <- data_import(file_name)
#' df
data_import <- function(name_dataset) {

  path_data <- data_path(name_dataset)

  df_out <- readr::read_csv(path_data,
                            col_types = readr::cols())

  return(df_out)
}


