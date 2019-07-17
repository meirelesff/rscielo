# ---
# TEST
# ---


# Load packages
library(tidyverse)
library(rscielo)


# Possibly functions (to avoid errors)
get_journal_safe <- possibly(get_journal, otherwise = NULL)
get_article_safe <- possibly(get_article, otherwise = NULL)

# List of al journal articles
articles <- get_journal_list() %>%
  pluck("id") %>%
  map(get_journal_safe, last_issue = FALSE) %>%
  bind_rows()

save(articles, file = "articles.Rda")

# Get articles' text
texts <- articles %>%
  pluck("article_id") %>%
  map(get_article_safe)
  
save(texts, file = "texts.Rda")
  




