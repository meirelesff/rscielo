#' Scrape meta-data from articles published by a journal hosted on Scielo
#'
#' \code{get_journal()} scrapes meta-data information from articles of a
#'  journal hosted on Scielo. In bilingual journals, articles' titles, abstracts
#'  and other relevant information are retrieved in the journal's main language
#'  used for publication (most of the time, it is English). The function can extract
#'  information from all articles ever published by the journal or only the ones
#'  in its latest issue.
#'
#' @param journal_id a character vector with the ID of the journal hosted on Scielo
#'  (the \code{get_ournal_id} function can be used to find the journal ID from its URL).
#' @param last_issue a logical vector, if \code{FALSE} scrapes all issues of the journal,
#'  if \code{TRUE} (default) only scrapes its last issue.
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
#' @seealso \code{\link{get_article_meta}}
#'
#' @details This functions scrapes several meta-data information, such as
#' author's names, articles' titles, year of publication, edition and number of pages,
#'  that can be summarized with specific \code{summary} method.
#'
#' @examples
#' \donttest{
#' df <- get_journal(journal_id = "1981-3821")
#' summary(df)
#' }

get_journal <- function(journal_id, last_issue = TRUE){


  # Inputs
  if(!is.character(journal_id) | nchar(journal_id) != 9) stop("Invalid 'id_journal'.")

  # Get the data
  scielo_data <- get_links(journal_id, last_issue) %>%
    purrr::map(get_xml_article) %>%
    purrr::discard(is.logical) %>%
    dplyr::bind_rows()

  message("\nDone.\n\n")

  # Return
  class(scielo_data) <- c("Scielo", class(scielo_data))
  scielo_data
}



# Function to extract the XML links for each article in a journal
get_links <- function(journal_id, last_issue = TRUE){


  # Get the page
  page <- build_journal_url(journal_id) %>%
    rvest::session()
  if(httr::status_code(page) != 200) stop("Journal not found.")

  journal <- rvest::html_nodes(page, "center .nomodel") %>%
    rvest::html_text()
  message(sprintf("\n\nScraping data from: %s\n\nMay take a while...", journal))

  # Test cases
  if(last_issue){ # Last issue

    ed <- page %>%
      rvest::html_nodes("b a") %>%
      rvest::html_attr("href")

    latest <- stringr::str_split(ed, "=|&", simplify = T)[, 4] %>%
      stringr::str_sub(10, 17) %>%
      as.numeric() %>%
      max(na.rm = T) %>%
      as.character()

    ed <- ed[stringr::str_detect(ed, latest)]

  } else { # All issues

    ed <- page %>%
      rvest::html_nodes("b a") %>%
      rvest::html_attr("href")
  }

  # Return
  ed %>%
    purrr::map(get_internal) %>%
    purrr::flatten_chr() %>%
    id_select() %>%
    build_article_url(journal_id)
}



# Function to get articles' links in each journal's issue
get_internal <- function(issues){

  # Inputs
  links <- xml2::session(issues) %>%
    rvest::html_nodes(".content div a") %>%
    rvest::html_attr("href")

  # Return
  links[stringr::str_detect(links, "sci_arttext")] %>%
    stringr::str_sub(1, 93) %>%
    unique()
}



# @S3 summary
#' @export
summary.Scielo <- function(object, ...) {


  # Inputs
  journal <- as.character(object$journal[1])
  total <- nrow(object)
  total_articles <- sum(nchar(object$abstract_en) > 1 | nchar(object$abstract_pt) > 0)
  mean_authors <- round(mean(object$n_authors[nchar(as.character(object$abstract_en)) > 1 |
                                                nchar(as.character(object$abstract_pt)) > 1], na.rm = T), 2)
  mean_authors <- ifelse(is.nan(mean_authors), "Not available", mean_authors)
  mean_size <- round(mean(object$n_pages[nchar(as.character(object$abstract_en)) > 1 |
                                           nchar(as.character(object$abstract_pt)) > 1], na.rm = T), 2)
  mean_size <- ifelse(is.nan(mean_size), "Not available", mean_size)


  # Outputs
  out <- list(journal = journal,
              total = total,
              total_articles = total_articles,
              mean_authors = mean_authors,
              mean_size = mean_size
  )

  class(out) <- "summary.Scielo"
  out
}



# @S3 print
#' @export
print.summary.Scielo <- function(x, ...){


  cat(sprintf("\n### JOURNAL: %s\n\n\n", x$journal))

  cat("\tTotal number of articles: ", x$total,
      "\n\tTotal number of articles (reviews excluded): ", x$total_articles)

  cat("\n\n\tMean number of authors per article: ", x$mean_authors,
      "\n\tMean number of pages per article: ", x$mean_size, "\n\n")
}
