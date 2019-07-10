#' Scrape publication and citation metrics of a journal hosted on Scielo
#'
#' \code{get_journal_metrics()} scrapes publication and citation information
#' of a jornal hosted on Scielo.
#'
#' @param journal_id a character vector with the ID of the journal hosted on
#' Scielo (the \code{get_journal_id} function can be used to find a journal's
#' ID from its URL).
#'
#' @importFrom magrittr "%>%"
#' @import graphics
#' @export
#'
#' @return The function returns a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item year: Year.
#'   \item n_issues: Number of issues in that year.
#'   \item n_articles: Number of articles in that year.
#'   \item granted_citations: Granted citations by the journal in that year.
#'   \item received_citations: Received citations by the journal in that year.
#'   \item avg_art_per_issues: Average number of articles published by the
#'   journal in that year.
#' }
#'
#' @examples
#' \dontrun{
#' df <- get_journal_metrics(journal_id = "1981-3821")
#' }

get_journal_metrics <- function(journal_id){


  # Input
  if(!is.character(journal_id) | nchar(journal_id) != 9) stop("Invalid 'id_journal'.")

  # Read the page
  page <- paste0("http://statbiblio.scielo.org/stat_biblio/index.php?state=15&lang=en&country=scl&YNG%5B%5D=all&CITED%5B%5D=", journal_id) %>%
    rvest::html_session()
  if(httr::status_code(page) != 200) stop("Journal not found.")

  # Get data
  metrics <- rvest::html_nodes(page, "td table") %>%
    rvest::html_table(header = T) %>%
    purrr::flatten_dfr() %>%
    dplyr::slice(-c(1, dplyr::n())) %>%
    stats::setNames(c("year", "n_issues", "n_articles", "granted_citations",
               "received_citations", "avg_art_per_issue")) %>%
    dplyr::mutate_all(list(~ stringr::str_replace_all(., intToUtf8(160), "") %>%
                             as.numeric()))

  class(metrics) <- c("scielo_metrics", class(metrics))

  # Return
  return(metrics)
}



# @S3 plot
#' @export
plot.scielo_metrics <- function(x, ...){


  # Set y axis
  y.max <- max(c(x$granted_citations, x$received_citations), na.rm = T) + 10

  # Main plot
  plot(x$year, x$granted_citations,
       type = "o",
       ylim = c(0, y.max), bty = "l", pch = 19, col = "#1693A5",
       cex.lab = 1.4, cex.main = 1.5, lwd = 1.3, main = "Number of citations",
       xlab = "Year", ylab = "Citations")

  # Lines and legend
  lines(x$year, x$received_citations, col = "#FBB829", type = "o", pch = 19, lwd = 1.3)
  legend("topleft", title = NULL, legend = c("Granted", "Received"), bty = "n", lty = c(1, 1),
         lwd = c(1.3, 1.3), col = c("#1693A5", "#FBB829"))
}

