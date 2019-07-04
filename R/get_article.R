#' Scrape text from a single article hosted on Scielo
#'
#' \code{get_article()} scrapes text from an article hosted on Scielo.
#'
#' @param x a character vector with the link or id of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, data.frame} with the following variables:
#'
#' \itemize{
#'   \item text: article's content (\code{character}).
#'   \item doi: article's Digital Object Identifier (DOI, (\code{character})).
#' }
#'
#'
#' @examples
#' \dontrun{
#' article <- get_article(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article <- function(x){

  url <-  id.select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s&lang=en", .)

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  text <- rvest::html_nodes(page, xpath = "//div[@id='article-body']") %>%
    rvest::html_text(text)

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text(text)

  data.frame(text, doi, stringsAsFactors = F)
}


