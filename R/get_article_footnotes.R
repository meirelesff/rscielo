#' Scrape footnotes from a single article hosted on Scielo
#'
#' \code{get_article_footnotes()} scrapes all the footnotes iin an article hosted
#' on Scielo.
#'
#' @param x a character vector with the link or id of the article hosted on
#' Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item footnote: article's footnotes (\code{character}).
#'   \item doi: article's Digital Object Identifier (\code{character}).
#' }
#'
#' @note Sometimes, the Scielo website is offline for maintaince,
#' in which cases this function will not work (i.e., users will get HTML status
#' different from the usual 200 OK).
#'
#' @examples
#' \donttest{
#' df <- get_article_fnotes(x = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_footnotes <- function(x){


  # Inputs
  url <-  id_select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s", .)
  if(!is.character(url)) stop("'link' must be a character vector.")

  # Read the page
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  # Get the data
  footnotes <- rvest::html_nodes(page, xpath = "//div[@class='fn']") %>%
   rvest::html_text() %>%
   stringr::str_replace_all(pattern = "[\n|\t|\r]", replacement = "")

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text()

  # Return
  tibble::tibble(footnotes = footnotes,
                 article_id = id_select(url),
                 doi = doi)
}


