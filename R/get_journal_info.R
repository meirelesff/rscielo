#' Scrape the description of a journal hosted on Scielo
#'
#' \code{get_journal_info()} scrapes the description (publisher, issn, and mission) information of a journal hosted on Scielo.
#'
#' @param id_journal a character vector with the ID of the journal hosted on Scielo (the \code{get_id_journal} function can be used to find the journal ID from its URL).
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns a \code{data.frame} with the journal's description.
#'
#' @examples
#' \dontrun{
#' journal_info <- get_journal_info(id_journal = "1981-3821")
#' }

get_journal_info <- function(id_journal){


  if(!is.character(id_journal) | nchar(id_journal) != 9) stop("Invalid 'id_journal'.")

  page <- sprintf("http://www.scielo.br/scielo.php?script=sci_serial&pid=%s&nrm=iso", id_journal) %>%
    html_session()

  if(status_code(page) != 200) stop("Journal not found.")

  publisher <- html_nodes(page, ".journalTitle") %>%
    html_text()

  issn <- html_nodes(page, ".issn") %>%
    html_text()

  mission <- html_nodes(page, "p font") %>%
    html_text()

  res <- data.frame(publisher = publisher,
                    issn = issn,
                    mission = mission)

  res
}



