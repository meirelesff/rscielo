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


  page <- rvest::html_session("http://www.scielo.br/scielo.php?script=sci_alphabetic&nrm=iso")

  if(httr::status_code(page) != 200) stop("Unnable to connect.")

  titles <- rvest::html_nodes(page, ".linkado > a") %>%
    rvest::html_text() %>%
    gsub("\n    |\n   ", "", .)

  urls <- rvest::html_nodes(page, ".linkado > a") %>%
    rvest::html_attrs() %>%
    unlist()

  ids <- sapply(urls, function(x){
    x_split <- strsplit(x, "=|&")[[1]]
    x_split[grep(x = x_split, pattern = "pid") + 1]
  })

  res <- data.frame(title = titles,
                    id    = ids,
                    url   = urls,
                    stringsAsFactors = F)
  res
}
