#' Scrape references from a single article hosted on Scielo
#'
#' \code{get_article_references()} scrapes references information from an article hosted on Scielo.
#'
#' @param url a character vector with the link of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, data.frame} with the following variables:
#'
#' \itemize{
#'   \item references: references
#'   \item doi: DOI.
#' }
#'
#'
#' @examples
#' \dontrun{
#' get_article_references <- get_article(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' summary(get_article_references)
#' }

get_article_references <- function(url){

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  references <- rvest::html_nodes(page, xpath = "//p[@class='ref']") %>%
    rvest::html_text() %>%
    stringr::str_replace_all(pattern = "[\n|\t|\r]", replacement = "") %>%
    stringr::str_replace_all(pattern = "[\\[][[:blank:]+]Links[[:blank:]+][\\]]", replacement = "")

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text(text)

  df <- data.frame(references,
                   doi,
                   stringsAsFactors = F)

  return(df)
}


