check_link <- function(link_in) {

  cli::cli_alert_info("Checking {link_in}")

  out_get <- list()

  try({
    out_get <- httr::GET(link_in)
  })

  status_code <- out_get$status_code

  expect_true(status_code == 200)

  return(invisible(TRUE))
}

test_that("test of main book links ", {

  book_links <- links_get()

  book_links <- c(
    book_links$book_github,
    book_links$blog_site,
    # TODO
    #book_links$book_blog_site
    book_links$book_amazon_ebook,
    book_links$book_amazon_print
  )

  flags <- purrr::map(book_links, check_link)

})
