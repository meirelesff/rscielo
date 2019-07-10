#' Scrape text from a single article hosted on Scielo
#'
#' \code{get_article()} scrapes text from an article hosted on Scielo.
#'
#' @param x a character vector with the link or id of the article hosted on
#' Scielo to be scrapped.
#'
#' @export
#'
#' @return The function returns a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item text: article's content (\code{character}).
#'   \item doi: article's Digital Object Identifier (DOI, (\code{character})).
#' }
#'
#'
#' @examples
#' \dontrun{
#' article <- get_article(x = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article <- function(x){


  # Inputs
  url <-  id_select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s", .)
  if(!is.character(url)) stop("'link' must be a character vector.")

  # Read page
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  # Get the data
  text <- get_article_strategy1(page)

  if(length(text) == 0) {

    # Second and third shots
    text <- get_article_strategy2(page)

  } else {

    # Last try
    text <-  paste(page, collapse = "\n")
  }

  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text()

  # Return
  tibble::tibble(text = text,
                 article_id = id_select(x),
                 doi = doi)
}
