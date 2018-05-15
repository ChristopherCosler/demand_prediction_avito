

# Prepare text ------------------------------------------------------------

cat("Prepare text information...  \n")

it <- train_test %$%
  str_to_lower(txt) %>%
  str_replace_all("[^[:alpha:]]", " ") %>%
  str_replace_all("\\s+", " ") %>%
  tokenize_word_stems(language = "russian") %>% 
  itoken()

vect <- create_vocabulary(it, ngram = c(1, 1), stopwords = stopwords("ru")) %>%
  prune_vocabulary(term_count_min = 10, doc_proportion_max = 0.4, vocab_term_max = 6500, doc_proportion_min = 0.001) %>% 
  vocab_vectorizer()

m_tfidf <- TfIdf$new(norm = "l2", sublinear_tf = T)
tfidf <-  create_dtm(it, vect) %>% text2vec::fit_transform(m_tfidf)
rm(it, vect, m_tfidf); gc() # clean up after yourself