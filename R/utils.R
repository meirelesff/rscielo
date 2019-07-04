# Function to extract meta-data from an article
get_xml_article <- function(link) {

  page <- try(xml2::read_xml(link), silent = T)
  if(class(page)[1] == "try-error") return(rep(NA, 13))


    lastname <- extract_node(page, "//article-meta/contrib-group/contrib/name/surname")
    firstname <- extract_node(page, "//article-meta/contrib-group/contrib/name/given-names")
    institution <- extract_node(page, "//article-meta/aff/institution")
    adress <- extract_node(page, "//article-meta/aff/addr-line")
    country <- extract_node(page, "//article-meta/aff/country")
    title <- extract_node(page, "//article-meta/title-group/article-title")
    year <- extract_node(page, "//article-meta/pub-date/year")
    journal <- extract_node(page, "//journal-title")
    volume <- extract_node(page, "//article-meta/volume")
    number <- extract_node(page, "//article-meta/numero")
    abstract_pt <- extract_node(page, "//article-meta/abstract[@xml:lang='pt']/p")
    abstract_en <- extract_node(page, "//article-meta/abstract[@xml:lang='en']/p")
    abstract_es <- extract_node(page, "//article-meta/abstract[@xml:lang='es']/p")
    keywords_pt <- extract_node(page, "//article-meta/kwd-group/kwd[@lng='pt']")
    keywords_en <- extract_node(page, "//article-meta/kwd-group/kwd[@lng='en']")
    keywords_es <- extract_node(page, "//article-meta/kwd-group/kwd[@lng='es']")
    f_pag <- extract_node(page, "//article-meta/fpage") %>% as.numeric()
    l_pag <- extract_node(page, "//article-meta/lpage") %>% as.numeric()
    n_refs <- extract_node(page, "//ref-list/ref") %>% length()
    doi <- extract_node(page, "//article-meta/article-id[@pub-id-type = 'doi']")
    article_id  <- extract_node(page, "//article-meta/article-id[1]")

    res <- data.frame(author = paste(firstname, lastname, collapse = "; ") %>% utf8(),
                      first_author_surname = lastname[1] %>% utf8(),
                      institution = paste(institution, collapse = "; ") %>% utf8(),
                      inst_adress = paste(adress, collapse = "; ") %>% utf8(),
                      country = paste(country, collapse = "; ") %>% utf8(),
                      title = utf8(title[1]),
                      year = year[1],
                      journal = utf8(journal),
                      volume = volume,
                      number = number,
                      first_page = f_pag,
                      last_page = l_pag,
                      abstract_pt = utf8(abstract_pt),
                      abstract_en = utf8(abstract_en),
                      abstract_es = utf8(abstract_es),
                      keywords_pt = paste(keywords_pt, collapse = "; ") %>% utf8(),
                      keywords_en = paste(keywords_en, collapse = "; ") %>% utf8(),
                      keywords_es = paste(keywords_es, collapse = "; ") %>% utf8(),
                      doi = doi,
                      article_id = article_id,
                      n_authors = length(firstname),
                      n_pages = l_pag - f_pag,
                      n_refs = n_refs,
                      stringsAsFactors = F)

    return(res)
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
is.scielo <- function(x) inherits(x, "Scielo")

# id select
id.select <- function(x){

  if(stringr::str_detect(x, "http")){
    article_id <- strsplit(x, "=|&")[[1]][4]

  }else{
    article_id <- x
  }

  return(article_id)
}

# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")
