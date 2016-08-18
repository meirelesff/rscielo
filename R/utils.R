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




# Function to extract XML nodes
extract_node <- function(page, path){

  nodes <- xml2::xml_find_all(page, path)
  if(length(nodes) == 0) return("")
  xml2::xml_text(nodes)
}



# Converts a character vector encoding to UTF-8
utf8 <- function(ch) iconv(ch, from = "UTF-8")



# Tests whether an object class is 'Scielo'
is.Scielo <- function(x) inherits(x, "Scielo")



# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")
