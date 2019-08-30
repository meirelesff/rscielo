#' Scrape a list with all the journals hosted on Scielo
#'
#' \code{get_journal_list()} scrapes the title, the numerical ID (pid) and the URL of
#' all journals hosted on Scielo.
#'
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @export
#'
#' @return The function returns a \code{tibble} with each journal's title, ID, and URL
#'
#' @examples
#' \donttest{
#' journal_list <- get_journal_list()
#' }

get_journal_list <- function(){


  # Read and return the data
  utils::read.csv("https://www.scielo.org/pt/periodicos/listar-por-assunto///?export=csv",
           stringsAsFactors = FALSE,
           encoding = "UTF-8") %>%
    stats::setNames(c("journal", "journal_url", "publisher", "status")) %>%
    dplyr::filter(!is.na(.data$journal_url)) %>%
    dplyr::filter(.data$journal_url != " ") %>%
    dplyr::mutate(journal_id = get_journal_id(.data$journal_url))
}



