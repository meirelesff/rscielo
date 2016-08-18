#' Get the ID of journal hosted on Scielo
#'
#' \code{get_id_journal()} extracts the numerical ID (pid) from a journal's url.
#'
#' @param url a character vector with the url of the journal hosted on Scielo.
#'
#' @export
#'
#' @return The function returns an character vector with the journal numerical ID.
#'
#' @examples
#' \dontrun{
#' id <- get_id_journal(url = "http://www.scielo.br/scielo.php?
#' script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#' }

get_id_journal <- function(url){


  if(!is.character(url) | length(url) != 1) stop("Invalid 'url'.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Journal not found.")

  strsplit(url, "=|&")[[1]][4]
}
