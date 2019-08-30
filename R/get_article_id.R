#' Get the ID of a scientific article hosted on Scielo
#'
#' \code{get_article_id()} extracts the ID of an article's URL
#'
#' @param url a character vector with the URL of an article hosted on Scielo.
#'
#' @export
#'
#' @return The function returns a \code{character} vector with the article ID.
#'
#' @examples
#' \donttest{
#' id <- get_article_id(url = "http://www.scielo.br/scielo.php?script=sci_arttext&
#' pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_id <- function(url){

  # Inputs
  if(!is.character(url)) stop("Invalid 'url'.")

  # Return
  id_select(url)
}
