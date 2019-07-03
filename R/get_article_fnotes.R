#' Scrape footnotes from a single article hosted on Scielo
#'
#' \code{get_article_fnotes()} scrapes footnote information from an article hosted on Scielo.
#'
#' @param url a character vector with the link of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, data.frame} with the following variables:
#'
#' \itemize{
#'   \item footnote: article's footnotes (\code{character}).
#'   \item doi: article's Digital Object Identifier (\code{character}).
#' }
#'
#'
#' @examples
#' \dontrun{
#' get_article_fnotes <- get_article_fnotes(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_fnotes <- function(url){

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  foot_notes <- rvest::html_nodes(page, xpath = "//div[@class='fn']") %>%
   rvest::html_text() %>%
   stringr::str_replace_all(pattern = "[\n|\t|\r]", replacement = "")

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text(text)

  data.frame(foot_notes, doi, stringsAsFactors = F)
}


