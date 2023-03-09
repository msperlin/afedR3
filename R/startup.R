.onAttach <- function(libname, pkgname) {

  my_links <- links_get()
  do_color <- crayon::make_style("#FF4141")
  this_pkg <- 'afedR3'

  data_files <- list.files(
    get_pkg_dir("data")
  )

  script_files <- list.files(
    get_pkg_dir("book-scripts"),
    recursive = TRUE
  )

  exercise_files <- list.files(
    get_pkg_dir("eoce/exercises"), recursive = TRUE
  )

  if (interactive()) {
    cli::cli_h1("Package {format_pkg_text('afedR3')} sucessfuly loaded")

    cli::cli_h2("Available resources")

    cli::cli_alert_success("{length(data_files)} data files")
    cli::cli_alert_success("{length(script_files)} book scripts for building data files")
    cli::cli_alert_success("{length(exercise_files)} end of chapter exercises")


    cli::cli_h2("Useful links")
    cli::cli_alert_success(
      paste0("Author site: ", cli::style_hyperlink(my_links$blog_site,
                                                                 my_links$blog_site))
    )

    cli::cli_alert_success(
      paste0("Book online (partial): ", cli::style_hyperlink(my_links$book_online, my_links$book_online ))
    )

    cli::cli_alert_success(
      paste0("Amazon site (full book): ", cli::style_hyperlink(my_links$book_amazon_ebook,
                                                                 my_links$book_amazon_ebook))
    )

    cli::cli_alert_success(
      paste0("Exercise solutions: ", cli::style_hyperlink(my_links$exercises_solutions,
                                                            my_links$exercises_solutions))
    )

    cli::cli_alert_success(
      paste0("Tutorial for compiling exercises: ", cli::style_hyperlink(my_links$link_blog_dyn_exerc,
                                                            my_links$link_blog_dyn_exerc))
    )

    # msg <- paste0('\nPackage ', this_pkg, ' sucessfully loaded!',
    #               ' Here youll find:\n',
    #               '\t', length(data_files), ' data files \n',
    #               '\t', length(script_files), ' book scripts for building data files \n',
    #               '\t', length(exercise_files), ' end of chapter exercises',
    #               '\n\n',
    #               "Useful links:\n",
    #               "\tAuthor site: ", cli::style_hyperlink(my_links$blog_site,
    #                                                       my_links$blog_site),
    #               "\n\tBook online (1-7 chapters): ", cli::style_hyperlink(my_links$book_online, my_links$book_online ),
    #               "\n\tAmazon site (full book): ", cli::style_hyperlink(my_links$book_amazon_ebook,
    #                                                                     my_links$book_amazon_ebook),
    #               "\n\tExercise solutions: ", cli::style_hyperlink(my_links$exercises_solutions,
    #                                                                my_links$exercises_solutions))
  } else {
    msg <- ''
  }

  msg <- ''
  packageStartupMessage(msg)

}
