# ---
# TEST
# ---


# Load packages
library(doParallel)
library(tidyverse)
library(rscielo)
library(foreach)


# Set up parallelism
registerDoParallel(cores = 4)


# Possibly functions (to avoid errors)
get_journal_safe <- possibly(get_journal, otherwise = NULL)
get_article_safe <- possibly(get_article, otherwise = NULL)


# List of al journal articles
journals <- get_journal_list() %>%
  pluck("id")

articles <- foreach(i = seq_along(journals)) %dopar% {
  
  get_journal_safe(journals[i], last_issue = FALSE)
}

articles <- bind_rows(articles)
save(articles, file = "articles.Rda")


# Get articles' text
article_ids <- articles %>%
  pluck("article_id") 

texts <- foreach(i = seq_along(article_ids)) %dopar% {
  
  get_article_safe(article_ids[i], output_text = FALSE)
}

save(texts, file = "texts.Rda")




