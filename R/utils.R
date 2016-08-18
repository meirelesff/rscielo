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
