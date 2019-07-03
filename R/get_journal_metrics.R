#' Scrape publication and citation metrics of a journal hosted on Scielo
#'
#' \code{get_journal_metrics()} scrapes publication and citation information of a jornal hosted on Scielo.
#'
#' @param id_journal a character vector with the ID of the journal hosted on Scielo (the \code{get_id_journal} function can be used to find the journal ID from its URL).
#'
#' @importFrom magrittr "%>%"
#' @import graphics
#' @export
#'
#' @return The function returns an object of class \code{data.frame} with the following variables:
#'
#' \itemize{
#'   \item year: Year.
#'   \item n_issues: Number of issues in that year.
#'   \item n_articles: Number of articles in that year.
#'   \item granted_citations: Granted citations by the journal in that year.
#'   \item received_citations: Received citations by the journal in that year.
#'   \item avg_art_per_issues: Average number of articles published by the journal in that year.
#' }
#'
#'
#' @examples
#' \dontrun{
#' df <- get_journal_metrics(id_journal = "1981-3821")
#' }

get_journal_metrics <- function(id_journal){


  if(!is.character(id_journal) | nchar(id_journal) != 9) stop("Invalid 'id_journal'.")

  page <- paste0("http://statbiblio.scielo.org/stat_biblio/index.php?state=15&lang=en&country=scl&YNG%5B%5D=all&CITED%5B%5D=", id_journal) %>%
    rvest::html_session()

  if(httr::status_code(page) != 200) stop("Journal not found.")

  metrics <- rvest::html_nodes(page, "td table") %>%
    rvest::html_table(header = T) %>%
    as.data.frame() %>%
    .[c(-1, -nrow(.)), ] %>%
    apply(2, function(x) as.numeric(gsub(intToUtf8(160), "", x))) %>%
    as.data.frame()

  colnames(metrics) <- c("year", "n_issues", "n_articles", "granted_citations",
                         "received_citations", "avg_art_per_issue")

  class(metrics) <- c("Scielo_metrics", "data.frame")

  metrics
}



# @S3 plot
#' @export
plot.Scielo_metrics <- function(x, ...){

  y.max <- max(c(x$granted_citations, x$received_citations), na.rm = T) + 10

  plot(x$year, x$granted_citations, type = "o", ylim = c(0, y.max), bty = "l", pch = 19, col = "#1693A5",
       cex.lab = 1.4, cex.main = 1.5, lwd = 1.3, main = "Number of citations",
       xlab = "Year", ylab = "Citations")

  lines(x$year, x$received_citations, col = "#FBB829", type = "o", pch = 19, lwd = 1.3)

  legend("topleft", title = NULL, legend = c("Granted", "Received"), bty = "n", lty = c(1, 1),
         lwd = c(1.3, 1.3), col = c("#1693A5", "#FBB829"))
}

