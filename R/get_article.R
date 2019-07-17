#' Scrape text from a single article hosted on Scielo
#'
#' \code{get_article()} scrapes the full text from an article hosted on Scielo.
#' In bilingual journals, the text retrieved is in the journal's main language
#'  used for publication (most of the time, it is English).
#'
#' @param x a character vector with the link or id of the article hosted on
#' Scielo to be scrapped.
#' @param output_text a logical indicating whether \code{get_article()} should return
#' a \code{character} vector or a \code{tibble} (defaults to \code{TRUE}).
#'
#' @export
#'
#' @return When the argument \code{output_text} is \code{TRUE}, the function returns
#' a \code{character} vector with the requested article's content. When \code{output_text}
#' is \code{FALSE}, the function returns a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item text: article's full text (\code{character}).
#'   \item doi: article's Digital Object Identifier (DOI, (\code{character})).
#' }
#'
#' @note Sometimes, the Scielo website is offline for maintaince,
#' in which cases this function will not work (i.e., users will get HTML status
#' different from the usual 200 OK).
#'
#' @examples
#' \dontrun{
#' article <- get_article(x = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article <- function(x, output_text = TRUE){


  # Inputs
  url <-  id_select(x) %>%
    sprintf("http://www.scielo.br/scielo.php?script=sci_arttext&pid=%s", .)
  if(!is.character(url)) stop("'link' must be a character vector.")

  # Read page
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  # Get the data
  metodo <- 1 # tirar
  text <- get_article_strategy1(page)

  if(length(text) == 0) {

    # Second and third shots
    text <- get_article_strategy2(page)
    metodo <- 2 # tirar

  } else {

    # Collapse text
    text <-  paste(text, collapse = "\n")
    metodo <- 3 # tirar
  }

  # Return
  # First case
  if(output_text) return(text)

  # Second case
  doi <- rvest::html_nodes(page, xpath = '//*[@id="doi"]') %>%
    rvest::html_text()

  tibble::tibble(text = text,
                 article_id = id_select(x),
                 doi = doi,
                 metodo = metodo)
}
