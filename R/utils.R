# Function to extract meta-data from an article
get_xml_article <- function (link){

  page <- try(xml2::read_xml(link), silent = T)

  if(class(page)[1] == "try-error"){
    warning("It was not possible to access the article metadata (XML). Returning NA")
    return(rep(NA))
  }

  names        <- rvest:::html_nodes(page, xpath = "//article-meta/contrib-group/contrib/name")
  authors_data <- rScielo:::nameList_to_dataFrame(xml2::as_list(names))

  institution <- rScielo:::extract_node(page, "//article-meta/aff/institution")
  institution <- gsub(x           = trimws(institution),
                      pattern     = "^,",
                      replacement = "")
  address     <- rScielo:::extract_node(page, "//article-meta/aff/addr-line")
  country     <- rScielo:::extract_node(page, "//article-meta/aff/country")

  institutions_data <- list(institution = rScielo:::utf8(institution) %>% unique(),
                            address     = rScielo:::utf8(address) %>% unique(),
                            country     = rScielo:::utf8(country) %>% unique())

  title_data <- rScielo:::get_ItemSeveralLanguages(item_name    = "title",
                                                   item_address = "//article-meta/title-group/article-title",
                                                   attr         = "lang",
                                                   page         = page)

  year        <- rScielo:::extract_node(page, "//article-meta/pub-date/year")
  journal     <- rScielo:::extract_node(page, "//journal-title")
  volume      <- rScielo:::extract_node(page, "//article-meta/volume")
  number      <- rScielo:::extract_node(page, "//article-meta/numero")

  abstract_data <- rScielo:::get_ItemSeveralLanguages(item_name    = "abstract",
                                                      item_address = "//article-meta/abstract",
                                                      attr = "lang",
                                                      page = page)

  keywords_data <- rScielo:::get_ItemSeveralLanguages(item_name    = "keywords",
                                                      item_address = "//article-meta/kwd-group/kwd",
                                                      attr = "lng",
                                                      page = page)

  scielo_id   <- rScielo:::extract_node(page, "//article-meta/article-id[not(@*)]")
  doi         <- rScielo:::extract_node(page, "//article-meta/article-id[@pub-id-type = 'doi']")
  f_pag       <- as.numeric(rScielo:::extract_node(page, "//article-meta/fpage"))
  l_pag       <- as.numeric(rScielo:::extract_node(page, "//article-meta/lpage"))
  n_refs      <- length(rScielo:::extract_node(page, "//ref-list/ref"))

  res         <- list(authors              = authors_data,
                      institutions         = institutions_data,
                      title                = title_data,
                      abstract             = abstract_data,
                      keywords             = keywords_data,
                      year                 = year[1],
                      journal              = rScielo:::utf8(journal),
                      volume               = volume,
                      number               = number,
                      first_page           = f_pag,
                      last_page            = l_pag,
                      scielo_id            = scielo_id,
                      doi                  = doi,
                      n_authors            = nrow(authors_data),
                      n_pages              = l_pag - f_pag + 1,
                      n_refs               = n_refs)

  class(res) = c(class(res), "Scielo_articleMeta")
  res
}



get_ItemSeveralLanguages <- function(item_name, item_address, attr, page = page){

  item_nodes     <- rvest:::html_nodes(page, xpath = item_address)

  if(length(item_nodes) == 0){
    return("")
  }

  item_languages <- rvest::html_attr(x = item_nodes, attr)

  item_textFrame <- data.frame(item_text = rScielo:::utf8(rvest::html_text(item_nodes)),
                              language  = item_languages,
                              stringsAsFactors = F)

  item_textFrame <- dplyr::summarise(dplyr::group_by(item_textFrame, language),
                                    text = paste(item_text, collapse = "; "))

  item_textFrame
}





# Function to extract XML nodes
extract_node <- function(page, path){

  nodes <- xml2::xml_find_all(page, path)
  if(length(nodes) == 0) return("")
  xml2::xml_text(nodes)
}


nameList_to_dataFrame <- function(x){
  n = length(x)

  if(n == 0){
    return(NA)
  }

  data_authors <- matrix(NA, ncol = 2, nrow = n)

  #i = 2
  for(i in 1:n){
    surname   = x[[i]]$surname[[1]]
    firstname = x[[i]]$`given-names`[[1]]

    data_authors[i,1] = ifelse(is.null(surname), NA, surname)
    data_authors[i,2] = ifelse(is.null(firstname), NA, firstname)
  }

  data_authors = data.frame(data_authors, stringsAsFactors = F)
  names(data_authors) = c("surname","given-names")

  data_authors
}


# Converts a character vector encoding to UTF-8
utf8 <- function(ch) iconv(ch, from = "UTF-8")

# Tests whether an object class is 'Scielo_articleMetaList'
is.Scielo_articleMetaList <- function(x) inherits(x, "Scielo_articleMetaList")

# Tests whether an object class is 'Scielo_articleMeta'
is.Scielo_articleMeta <- function(x) inherits(x, "Scielo_articleMeta")

# Tests whether an object class is 'Scielo_metrics'
is.Scielo_metrics <- function(x) inherits(x, "Scielo_metrics")


# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")


