#' Get the ID of a journal hosted on Scielo
#'
#' \code{get_journal_id()} extracts the numerical ID (pid) from one or more
#'  journals' URLs.
#'
#' @param url a character vector with the URL of one or more journals hosted on Scielo.
#'
#' @export
#'
#' @return The function returns a \code{character} vector with the journals ID.
#'
#' @examples
#' \donttest{
#' id <- get_journal_id(url = "http://www.scielo.br/scielo.php?
#' script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#' }

get_journal_id <- function(url){

  # Inputs
  if(!is.character(url) | !stringr::str_detect(url, "scielo")) stop("Invalid 'url'.")

  # Return
  ids <- stringr::str_split(url, "=|&", simplify = T)[, 4]
}





