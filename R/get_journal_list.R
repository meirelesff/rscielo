#' Scrape a list with all the journals hosted on Scielo
#'
#' \code{get_journal_list()} scrapes the title, the numerical ID (pid) and the URL of
#' all journals hosted on Scielo.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns a \code{tibble} with each journal's title, ID, and URL
#'
#' @examples
#' \donttest{
#' journal_list <- get_journal_list()
#' }

get_journal_list <- function(){


  # Read the page
  page <- rvest::html_session("http://www.scielo.br/scielo.php?script=sci_alphabetic&nrm=iso")
  if(httr::status_code(page) != 200) stop("Unnable to connect.")

  # Get the data
  titles <- rvest::html_nodes(page, ".linkado > a") %>%
    rvest::html_text() %>%
    stringr::str_replace_all("\n    |\n   ", "")

  urls <- rvest::html_nodes(page, ".linkado > a") %>%
    rvest::html_attrs() %>%
    as.character()

  ids <- stringr::str_split(urls, "=|&", simplify = T)[, 4]

  # Return
  tibble::tibble(title = titles,
                 id = ids,
                 url = urls)
}
