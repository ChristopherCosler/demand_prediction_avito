
cat("Set up R...  \n")

libraries <- c("dplyr", "mlr", "ggplot2", "data.table", "text2vec", "tokenizers", "stopwords", "magrittr", "lubridate", "stringr", "forcats", "tidyr", "xgboost")
sapply(libraries, require, character.only = TRUE)

