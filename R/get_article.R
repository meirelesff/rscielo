#' Scrape meta-data from a unique article hosted on Scielo
#'
#' \code{get_article()} scrapes meta-data information of an article hosted on Scielo.
#'
#' @param url a character vector with the link of the article hosted on Scielo to be scraped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, data.frame} with the following variables:
#'
#' \itemize{
#'   \item author: Author name.
#'   \item title: Article title.
#'   \item year: Year of publication.
#'   \item journal: Journal name.
#'   \item volume: Volume.
#'   \item number: Number.
#'   \item first_page: Article's first page.
#'   \item last_page: Article's last page
#'   \item abstratc: Article's abstract.
#'   \item keywords: Article's keywords.
#'   \item doi: DOI.
#'   \item n_authors: Number of authors.
#'   \item n_pages: Number of pages.
#' }
#'
#' @details This functions scrapes several meta-data information, such as author's names, article title, year of publication, edition and number of pages.
#'
#' @examples
#' \dontrun{
#' article <- get_article(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' summary(article)
#' }

get_article <- function(url){

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  article_id <- strsplit(url, "=|&")[[1]][4]

  sprintf("http://www.scielo.br/scieloOrg/php/articleXML.php?pid=%s&lang=en", article_id) %>%
    get_xml_article()
}


