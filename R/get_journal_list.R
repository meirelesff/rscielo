#' Scrape a list with all the journals hosted on Scielo
#'
#' \code{get_journal_list()} scrapes the title, numerical ID (pid) and URL of all journals hosted on Scielo.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns a \code{data.frame} with each journal's title, ID, and URL
#'
#' @examples
#' \dontrun{
#' journal_list <- get_journal_list()
#' }

get_journal_list <- function(){


  page <- html_session("http://www.scielo.br/scielo.php?script=sci_alphabetic&nrm=iso")

  if(status_code(page) != 200) stop("Unnable to connect.")

  titles <- html_nodes(page, ".linkado > a") %>%
    html_text() %>%
    gsub("\n    |\n   ", "", .)

  urls <- html_nodes(page, ".linkado > a") %>%
    html_attrs() %>%
    unlist()

  ids <- sapply(urls, function(x) strsplit(x, "=|&")[[1]][4])

  res <- data.frame(title = titles,
                    id = ids,
                    url = urls)

  res
}
