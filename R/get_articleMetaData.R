#' Scrape meta-data from a single article hosted on Scielo
#'
#' \code{get_articleMetaData()} scrapes meta-data information from an article hosted on Scielo.
#'
#' @param url a character vector with the link of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, list} with the following variables:
#'
#' \itemize{
#'   \item authors: A data.frame with authors names and last names.
#'   \item institutions: A list about the author's institutions.
#'   \item title: A data.frame with the article title in all available languages.
#'   \item abstract: A data.frame with the article's abstract in all available languages.
#'   \item keywords: A data.frame with the article's keywords in all available languages.
#'   \item year: Year of publication.
#'   \item journal: Journal name.
#'   \item volume: Journal Volume.
#'   \item number: Journal Number.
#'   \item first_page: Article's first page in the journal edition.
#'   \item last_page: Article's last page in the journal edition.
#'   \item scielo_id: Article's identification number in the Scielo Database.
#'   \item doi: DOI.
#'   \item n_authors: Number of authors.
#'   \item n_pages: Number of pages.
#'   \item n_refs: Number of references.
#' }
#'
#'
#' @details This functions scrapes several meta-data information, such as author's names, article title, year of publication, edition and number of pages.
#'
#' @examples
#' \dontrun{
#' article <- get_articleMetaData(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' summary(article)
#' }

get_articleMetaData <- function(url){

  if(!is.character(url)) stop("'link' must be a character vector.")
  page <- rvest::html_session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  url_split  <- strsplit(url, "=|&")[[1]]
  article_id <- url_split[grep(x = url_split, pattern = "pid") + 1]

  address <- sprintf("http://www.scielo.br/scieloOrg/php/articleXML.php?pid=%s", article_id)

  rScielo:::get_xml_article(address)
}


