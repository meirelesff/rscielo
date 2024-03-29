#' Scrape meta-data from a single article hosted on Scielo
#'
#' \code{get_article_meta()} scrapes meta-data information from an article
#' hosted on Scielo.
#'
#' @param x a character vector with the link or id of the article hosted on
#' Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns a \code{tibble} with the following variables:
#'
#' \itemize{
#'   \item author: Author name.
#'   \item first_author_surname: First author surname.
#'   \item institution: Author's institution.
#'   \item inst_adress: Author's institution address.
#'   \item country: Author's country.
#'   \item title: Article title.
#'   \item year: Year of publication.
#'   \item journal: Journal name.
#'   \item volume: Volume.
#'   \item number: Number.
#'   \item first_page: Article's first page.
#'   \item last_page: Article's last page
#'   \item abstratc: Article's abstract.
#'   \item keywords: Article's keywords.
#'   \item article_id:
#'   \item doi: DOI.
#'   \item n_authors: Number of authors.
#'   \item n_pages: Number of pages.
#'   \item n_refs: Number of references.
#' }
#'
#' @note Sometimes, the Scielo website is offline for maintaince,
#' in which cases this function will not work (i.e., users will get HTML status
#' different from the usual 200 OK).
#'
#' @seealso \code{\link{get_journal}}
#'
#' @details This functions scrapes several meta-data information, such as
#' author's names, article title, year of publication, journal issue and number
#' of pages.
#'
#' @examples
#' \donttest{
#' article_meta <- get_article_meta(x = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }

get_article_meta <- function(x){


  # Inputs
  url <- id_select(x) %>%
    sprintf("http://www.scielo.br/scieloOrg/php/articleXML.php?pid=%s", .)
  if(!is.character(url)) stop("'link' must be a character vector.")

  # Test the page
  page <- rvest::session(url)
  if(httr::status_code(page) != 200) stop("Article not found.")

  # Return
  get_xml_article(url)
}

