#' Scrape the description of a journal hosted on Scielo
#'
#' \code{get_journal_info()} scrapes the description (publisher, issn, and mission)
#'  information of a journal hosted on Scielo.
#'
#' @param journal_id a character vector with the ID of the journal hosted on
#' Scielo (the \code{get_journal_id} function can be used to find a journal's ID
#' from its URL).
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @note Sometimes, the Scielo website is offline for maintaince,
#' in which cases this function will not work (i.e., users will get HTML status
#' different from the usual 200 OK).
#'
#' @return The function returns a \code{tibble} with the journal's description.
#'
#' @examples
#' \dontrun{
#' journal_info <- get_journal_info(journal_id = "1981-3821")
#' }

get_journal_info <- function(journal_id){


  # Inputs
  if(!is.character(journal_id) | nchar(journal_id) != 9) stop("Invalid 'journal_id'.")

  # Read page
  page <- sprintf("http://www.scielo.br/scielo.php?script=sci_serial&pid=%s&nrm=iso", journal_id) %>%
    rvest::html_session()
  if(httr::status_code(page) != 200) stop("Journal not found.")

  # Get the data
  publisher <- rvest::html_nodes(page, ".journalTitle") %>%
    rvest::html_text()

  issn <- rvest::html_nodes(page, ".issn") %>%
    rvest::html_text()

  mission <- rvest::html_nodes(page, "p font") %>%
    rvest::html_text()

  # Return
  tibble::tibble(publisher = publisher,
                 issn = issn,
                 mission = mission)

}



