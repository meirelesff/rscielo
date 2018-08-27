#' Scrape the complete text from a single article hosted on Scielo
#'
#' \code{get_articleText()} scrapes the text from an article hosted on Scielo.
#'
#' @param url a character vector with the link of the article hosted on Scielo to be scrapped.
#'
#' @importFrom magrittr "%>%"
#' @export
#'
#' @return The function returns an object of class \code{Scielo, list} with the following variables:
#'
#' \itemize{
#'   \item text: A single-valued character vector containing the entire text.
#' }
#'
#'
#' @details [...].
#'
#' @examples
#' \dontrun{
#' article <- get_articleText(url = "http://www.scielo.br/scielo.php?
#' script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en")
#' }
get_articleText <- function(url){

        page <- rvest::html_session(url)

        if(httr::status_code(page) != 200){
                warning("Text not found")
                return("")
        }

        text <- rvest::html_nodes(page, xpath = "//div[@id='article-body']//p|//div[@id='S01-body']//p")
        text <- rvest::html_text(text)

        if(length(text)==0) {
                articleText <- rScielo:::get_articleText_strategy2(page)
        }else{
                articleText = paste(text, collapse = " \n ")
        }

        articleText
}



get_articleText_strategy2 <- function(page){
        test_strategy2 = rvest::html_nodes(page, xpath = "//hr")

        if(length(test_strategy2) == 1){
                articleText <- rScielo:::get_articleText_strategy3(page)
        }else{

                xpathScieloPatterns <- c("//div[@class='content']/div/font/p",
                                         "//div[@class='content']/div/font/p/preceding-sibling::comment()",
                                         "//div[@class='content']/div/font/p/comment()",
                                         "//div[@class='content']/div/p",
                                         "//div[@class='content']/div/p/preceding-sibling::comment()",
                                         "//div/hr")

                nodes <- page %>%
                        rvest::html_nodes(xpath = paste(xpathScieloPatterns, collapse ="|"))

                tag_names <- purrr::map(nodes, rvest::html_tag) %>%
                        unlist()
                nodes = nodes[(dplyr::last(which(tag_names=="hr"))+1):length(nodes)]
                complete_content    <- rvest::html_text(nodes)

                references_location <- grep(x = complete_content, pattern = "[[:blank:]]ref[[:blank:]]")
                if(length(references_location)>0){
                        articleText       <- complete_content[1:(first(references_location) - 2)]
                }else{
                        articleText       <- complete_content[-length(complete_content)]
                }

                articleText = paste(articleText, collapse = " \n ")
        }

        articleText
}



get_articleText_strategy3 <- function(page){
        xpathScieloPatterns <- c("//div[@class='content']/div/font/p/..",
                                 "//div[@class='content']/div/font/p/../preceding-sibling::comment()",
                                 "//div[@class='content']/div/font/p/../comment()",
                                 "//div[@class='content']/div/p/font",
                                 "//div[@class='content']/div/p/font/preceding-sibling::comment()",
                                 "//div[@class='content']/div//preceding-sibling::comment()")

        font_nodes <- page %>%
                rvest::html_nodes(xpath = paste(xpathScieloPatterns, collapse="|"))

        if(length(font_nodes) < 3){
                articleText <- page %>%
                        rvest::html_nodes(xpath = "//p[@align = 'left']") %>%
                        rvest::html_text()

                articleText = paste(articleText, collapse = " \n ")

        }else{
                # Finding which font size is the most used
                font_sizes <- purrr::map(font_nodes, function(x) {

                        size_attribute = rvest::html_attr(x, "size")

                        if(length(size_attribute)==0){
                                size_attribute = ""
                        }

                        size_attribute}) %>%
                        unlist() %>%
                        as.numeric()

                font_sizes_table = table(font_sizes) %>%
                        dplyr::as_tibble() %>%
                        dplyr::arrange(-n)

                font_1stUsed = font_sizes_table %>%
                        dplyr::filter(n >= 2) %>%
                        .$font_sizes %>%
                        .[1] %>%
                        as.numeric()

                font_2ndUsed = font_sizes_table %>%
                        dplyr::filter(n >= 2) %>%
                        .$font_sizes %>%
                        .[2] %>%
                        as.numeric()

                text_start <- dplyr::first(which(font_sizes == font_1stUsed))

                if(!is.na(font_2ndUsed)){
                        ref_start  <- dplyr::last(which(font_sizes  == font_2ndUsed))

                        text_data <- font_nodes[text_start : (ref_start - 1)] %>%
                                rvest::html_text() %>%
                                tibble::tibble(text = .)%>%
                                dplyr::filter(row_number() > 3 | nchar(text) > 50)
                }else{
                        text_data <- font_nodes[text_start : length(font_nodes)] %>%
                                rvest::html_text() %>%
                                stringr::str_replace_all(pattern = "[[:punct:]][[:blank:]]{0,2}Links?[[:blank:]]{0,2}[[:punct:]]",
                                                         replacement = "") %>%
                                stringr::str_trim() %>%
                                tibble::tibble(text = .) %>%
                                dplyr::filter(nchar(text) > 50)

                        references <- page %>%
                                rvest::html_nodes(xpath = "//comment()/ancestor::p|//comment()/ancestor::font") %>%
                                rvest::html_text() %>%
                                stringr::str_replace_all(pattern = "[[:punct:]][[:blank:]]{0,2}Links?[[:blank:]]{0,2}[[:punct:]]",
                                                         replacement = "") %>%
                                stringr::str_trim() %>%
                                tibble::tibble(text = .)

                        if(nrow(references) > 0 ){
                                references$test = 1

                                text_data <- dplyr::left_join(text_data, references, by = "text")

                                min_line = text_data %>%
                                        dplyr::left_joinmutate(line = 1:n()) %>%
                                        dplyr::left_joinfilter(!is.na(test)) %>%
                                        .$line %>%
                                        min()

                                text_data <- text_data[1:(min_line-1),"text"]
                        }

                        font_nodes

                }


                header_data =
                        rvest::html_nodes(page, xpath = "//blockquote//descendant-or-self::b//ancestor-or-self::blockquote//p") %>%
                        rvest::html_text() %>%
                        tibble::tibble(text = .)

                text <- dplyr::anti_join(text_data, header_data) %>% .$text

                articleText = paste(text, collapse = " \n ")
        }

        articleText
}


