
tfidf <- data.frame(as.matrix(tfidf))
train_test <- cbind(train_test, tfidf) %>% dplyr::select(-txt)

cat("Split into original train and test...\n")
test <- train_test[((length(y)+1):nrow(train_test)),]
train_test <- train_test[-((length(y)+1):nrow(train_test)),]
train <- train_test ; rm(train_test) ; gc() # copying does not change memory usage
train$y <- y

# Train model -------------------------------------------------------------

# From the benchmark experiments, we know that xgboost worked best and we have an idea about the parameters
# As mlr cannot handle sparce matrices, we implement it for the whole dataset directly via xgboost

cat("Training model...\n")

net <- neuralnet::neuralnet(as.formula(paste0("y ~ ", paste0(names(train)[-ncol(train)], collapse = " + "))), data = train)
pred <- neuralnet::compute(x = net, covariate = train[,-ncol(train)])

# RMSE
print(sqrt(sum( ( pred$net.result - y)^2  ) / length(y)))

rm(train) ; gc()

# Create submission -------------------------------------------------------

pred <- neuralnet::compute(x = net, covariate = test)$net.result

cat("Creating submission file in './submissions/'...\n")
data.frame(item_id = item_id, deal_probability = pred) %>% write.csv(paste0("submissions/neuralnet_submission", "_", format(Sys.time(), format = '%Y%m%d_%H%M%S'), ".csv"), row.names = FALSE)

