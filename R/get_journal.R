#' Scrape meta-data from all the articles of a journal hosted on Scielo
#'
#' \code{get_journal()} scrapes meta-data information from all the articles of a journal hosted on Scielo.
#'
#' @param id_journal a character vector with the ID of the journal hosted on Scielo (the \code{get_id_journal} function can be used to find the journal ID from its URL).
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
#' @details This functions scrapes several meta-data information, such as author's names, articles' titles, year of publication, edition and number of pages, that can be summarized with specific \code{summary} method.
#'
#' @examples
#' \dontrun{
#' df <- get_journal(id_journal = "1981-3821")
#' summary(df)
#' }

get_journal <- function(id_journal){


  if(!is.character(id_journal) | nchar(id_journal) != 9) stop("Invalid 'id_journal'.")

  scielo_data <- get_links(id_journal) %>%
    lapply(get_xml_article) %>%
    do.call("rbind", .)

  cat("\n\nDone.\n\n")

  class(scielo_data) <- c("Scielo", "data.frame")
  scielo_data
}



# Function to extract the XML links for each article in a journal
get_links <- function(id_journal){


  page <- sprintf("http://www.scielo.br/scielo.php?script=sci_issues&pid=%s&lng=en&nrm=iso", id_journal) %>%
    rvest::html_session()

  if(httr::status_code(page) != 200) stop("Journal not found.")

  journal <- rvest::html_nodes(page, "center .nomodel") %>%
    rvest::html_text()
  cat(sprintf("\n\nScraping articles from: \n\n\n\t%s\n\n\n...", journal))

  editions <- page %>%
    rvest::html_nodes("b a") %>%
    rvest::html_attr("href")

  get_internal <- function(editions){
    links <- xml2::read_html(editions) %>%
      rvest::html_nodes(".content div a") %>%
      rvest::html_attr("href")
    links[grepl("sci_arttext", links)]
  }

  lapply(editions, get_internal) %>%
    unlist() %>%
    substr(56, 78) %>%
    sprintf("http://www.scielo.br/scieloOrg/php/articleXML.php?pid=%s&lang=en", .)
}



# Function to extract meta-data from an article
get_xml_article <- function(link) {


  page <- try(xml2::read_xml(link), silent = T)
  if(class(page)[1] == "try-error") return(rep(NA, 13))

  lastname <- extract_node(page, "//article-meta/contrib-group/contrib/name/surname")
  firstname <- extract_node(page, "//article-meta/contrib-group/contrib/name/given-names")
  title <- extract_node(page, "//article-meta/title-group/article-title")
  year <- extract_node(page, "//article-meta/pub-date/year")
  journal <- extract_node(page, "//journal-title")
  volume <- extract_node(page, "//article-meta/volume")
  number <- extract_node(page, "//article-meta/numero")
  abstract <- extract_node(page, "//article-meta/abstract/p")
  keywords <- extract_node(page, "//article-meta/kwd-group/kwd")
  doi <- extract_node(page, "//article-meta/article-id[@pub-id-type = 'doi']")
  f_pag <- extract_node(page, "//article-meta/fpage") %>% as.numeric()
  l_pag <- extract_node(page, "//article-meta/lpage") %>% as.numeric()

  res <- data.frame(author = paste(firstname, lastname, collapse = "; ") %>% utf8(),
                    title = utf8(title[1]),
                    year = year[1],
                    journal = utf8(journal),
                    volume = volume,
                    number = number,
                    first_page = f_pag,
                    last_page = l_pag,
                    abstract = utf8(abstract[1]),
                    keywords = paste(keywords, collapse = "; ") %>% utf8(),
                    doi = doi,
                    n_authors = length(firstname),
                    n_pages = l_pag - f_pag,
                    stringsAsFactors = F)

  res
}



# @S3 summary
#' @export
summary.Scielo <- function(object, ...) {


  journal <- as.character(object$journal[1])
  total <- nrow(object)
  total_articles <- nrow(object[nchar(as.character(object$abstract)) > 1,])
  years <- range(as.numeric(as.character(object$year)), na.rm = T)
  mean_authors <- round(mean(object$n_authors[nchar(as.character(object$abstract)) > 1], na.rm = T), 2)
  mean_size <- round(mean(object$n_pages[nchar(as.character(object$abstract)) > 1], na.rm = T), 2)

  out <- list(journal = journal,
              total = total,
              total_articles = total_articles,
              years = years,
              mean_authors = mean_authors,
              mean_size = mean_size
  )

  class(out) <- "summary.Scielo"
  out
}



# @S3 print
#' @export
print.summary.Scielo <- function(x, ...){


  cat(sprintf("\n### JOURNAL SUMMARY: %s (%s - %s)\n\n\n", x$journal, x$years[1], x$years[2]))

  cat("\tTotal number of articles: ", x$total,
      "\n\tTotal number of articles (reviews excluded): ", x$total_articles)

  cat("\n\n\tMean number of authors per article: ", x$mean_authors,
      "\n\tMean number of pages per article: ", x$mean_size, "\n\n")
}
