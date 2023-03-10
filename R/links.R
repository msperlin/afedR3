#' Get official links from book
#'
#' Use this function in the book so that all links are updated in a single location.
#'
#' @return A list with links
#' @export
#'
#' @examples
#'
#' print(links_get())
links_get <- function() {

  my_l <- list(
    book_blog_site  = 'https://www.msperlin.com/publication/2020_book-afedr-en/',
    book_blog_zip = 'https://www.msperlin.com/files/afedr-files/afedR-code-and-data.zip',
    book_amazon_ebook = "https://www.amazon.com/dp/B084LSNXMN",
    book_amazon_print = "https://www.amazon.com/dp/171062731X",
    book_amazon_hardcover = "https://www.amazon.com/dp/B08XSL5R4X",
    book_github = 'https://github.com/msperlin/afedR3',
    book_online = "https://www.msperlin.com/afedr",
    blog_site = 'https://www.msperlin.com',
    exercises_solutions = 'https://msperlin.com/afedr/afedr-eoc-solutions',
    link_script_example = 'https://github.com/msperlin/afedR3/blob/main/inst/extdata/others/S_Example_Script.R',
    link_blog_dyn_exerc = 'https://www.msperlin.com/post/2023-03-09-compiling-exercises-afedR3/'
  )

  return(my_l)

}
