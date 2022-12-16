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

  my_l <- list(book_blog  = 'TODO',
               book_amazon_ebook = "https://www.amazon.com.br/dp/B0BK2V4HTB",
               book_amazon_print = "https://www.amazon.com/dp/B0BJYJQ92Q",
               book_amazon_hardcover = "https://www.amazon.com/dp/B0BJYMHWLN",
               book_github_vdr = 'https://github.com/msperlin/afedR3',
               book_online = "https://www.msperlin.com/afedR3",
               blog_site = 'https://www.msperlin.com',
               adfer_web = "https://www.msperlin.com/afeR3",
               exercises_solutions = "TODO")

  return(my_l)

}
