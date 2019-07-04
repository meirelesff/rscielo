#' Scrape bibliographic references from a single article hosted on Scielo
#'
#' \code{get_article_references()} scrapes bibliographic references information from an article hosted on Scielo.
#'
#' @param x a character vector with the link or of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, data.frame} with the following variables:
#'
#' \itemize{
#'   \item references: an article's bibliographic reference (\code{character}).
#'   \item doi: article's Digital Object Identifier (DOI).
#' }
#'
#'
#' @examples
#' \dontrun{
#' get_article_references <- get_article(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_references <- function(x){

  url <-  id.select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s&lang=en", .)

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  references <- rvest::html_nodes(page, xpath = "//p[@class='ref']") %>%
    rvest::html_text() %>%
    stringr::str_replace_all(pattern = "[\n|\t|\r]", replacement = "") %>%
    stringr::str_replace_all(pattern = "[\\[][[:blank:]+]Links[[:blank:]+][\\]]", replacement = "")

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text(text)

  data.frame(references, doi, stringsAsFactors = F)
}


