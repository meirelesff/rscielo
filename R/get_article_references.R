#' Scrape bibliographic references from a single article hosted on Scielo
#'
#' \code{get_article_references()} scrapes a list of bibliographic references
#' cited by an article hosted on Scielo.
#'
#' @param x a character vector with the link or the id of the article hosted on Scielo
#' to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item references: an article's bibliographic reference (\code{character}).
#'   \item doi: article's Digital Object Identifier (DOI).
#' }
#'
#' @note Sometimes, the Scielo website is offline for maintaince,
#' in which cases this function will not work (i.e., users will get HTML status
#' different from the usual 200 OK).
#'
#' @examples
#' \dontrun{
#' refs <- get_article_references(x = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_references <- function(x){


  # Inputs
  url <-  id_select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s", .)
  if(!is.character(url)) stop("'link' must be a character vector.")

  # Read the page
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  # Get the data
  references <- rvest::html_nodes(page, xpath = "//p[@class='ref']") %>%
    rvest::html_text() %>%
    stringr::str_replace_all(pattern = "[\n|\t|\r]", replacement = "") %>%
    stringr::str_replace_all(pattern = "[\\[][[:blank:]+]Links[[:blank:]+][\\]]",
                             replacement = "")

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text()

  # Return
  tibble::tibble(references = references,
                 article_id = id_select(x),
                 doi = doi)
}


