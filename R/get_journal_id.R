#' Get the ID of journal hosted on Scielo
#'
#' \code{get_journal_id()} extracts the numerical ID (pid) from a journal's url.
#'
#' @param url a character vector with the url of the journal hosted on Scielo.
#'
#' @export
#'
#' @return The function returns an character vector with the journal numerical ID.
#'
#' @examples
#' \dontrun{
#' id <- get_journal_id(url = "http://www.scielo.br/scielo.php?
#' script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#' }

get_journal_id <- function(url){

  # Inputs
  if(!is.character(url) | length(url) != 1) stop("Invalid 'url'.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Journal not found.")

  # Return
  strsplit(url, "=|&")[[1]][4]
}
