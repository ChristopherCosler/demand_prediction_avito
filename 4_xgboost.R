

# Sparse matrix -----------------------------------------------------------
# Given the size of the full data set, we better convert it to a sparse matrix
cat("Convert train_test to sparse matrix...\n")


# We convert train_test to a sparse model matrix and merge that with the words dataset
train_test <- (Matrix::sparse.model.matrix(object = ~ . - 1, train_test)) %>% cbind(., tfidf)
rm(tfidf) ; gc() # clean up


# We do three splits now
# 1.) Split into the original training and test data
# 2.) Split the training data into two, to have a smaller test set

cat("Split into original train and test...\n")
test <- train_test[((length(y)+1):nrow(train_test)),]
train_test <- train_test[-((length(y)+1):nrow(train_test)),]
train <- train_test ; rm(train_test) ; gc() # copying does not change memory usage

cat("Create a smaller partition of train as a small testing set for tuning xgboost...\n")
tri <- caret::createDataPartition(y, p = 0.9, list = F) %>% c()
val <- xgb.DMatrix(data = train[-tri, ], label = y[-tri])
train <- xgb.DMatrix(data = train[tri, ], label = y[tri])
cols <- colnames(train)


# Train model -------------------------------------------------------------

# From the benchmark experiments, we know that xgboost worked best and we have an idea about the parameters
# As mlr cannot handle sparce matrices, we implement it for the whole dataset directly via xgboost

cat("Training model...\n")
p <- list(objective = "reg:logistic",
          booster = "gbtree",
          eval_metric = "rmse",
          nthread = 8,
          eta = 0.05,
          max_depth = 18,
          min_child_weight = 9,
          gamma = 0,
          subsample = 0.75,
          colsample_bytree = 0.7,
          alpha = 1.95,
          lambda = 0,
          nrounds = 5000)

m_xgb <- xgb.train(params = p, data = train, p$nrounds, list(val = val), 
                   print_every_n = 1, early_stopping_rounds = 50)

pred <- predict(m_xgb, test)

# Create submission -------------------------------------------------------

cat("Creating submission file in './submissions/'...\n")
data.frame(item_id = item_id, deal_probability = pred) %>% write.csv(paste0("submissions/xgboost_submission", "_", format(Sys.time(), format = '%Y%m%d_%H%M%S'), ".csv"), row.names = FALSE)

                                                                     