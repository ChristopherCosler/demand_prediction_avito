
# Split data --------------------------------------------------------------

# For benchmarking with mlr, we need it in a data frame class
# We do not need the test dataset for benchmarking
# We do not need a smaller subset of the train data as we do CV

# Split of the train part
train_test <- train_test[-((length(y)+1):nrow(train_test)),] %>% dplyr::select(-txt)
train <- train_test # copying does not change memory usage
train$deal_probability <- y
rm(train_test) ; gc() # clean up


# Setup mlr ---------------------------------------------------------------

cat("\n Setup Learners...  \n")
task <- mlr::makeRegrTask(id = "avito", data = train, target = "deal_probability")
task

# mlr preprocessing
# colsToKeep <- c("deal_probability", "parent_category_name", "category_name", "price", "user_type", grep(names(train), pattern = "Word", value = TRUE))
# colsToDrop <- setdiff(names(train), colsToKeep)
# task <- dropFeatures(task, colsToDrop)
# task <- mergeSmallFactorLevels(task)

# Benchmark on small sample -----------------------------------------------

cat("Benchmark Learners...  \n")

### List of learners to be compared
learners = list(
  makeLearner("regr.glm"), 
  makeLearner("regr.xgboost"),
  makeLearner("regr.bst"), 
  makeLearner("regr.elmNN"), 
  makeLearner("regr.fnn")
)

### Choose the resampling strategy
rdesc <- makeResampleDesc("CV", iters = 2)

### Conduct the benchmark experiment
bmr = benchmark(learners = learners, tasks = task, resamplings = rdesc, measures = rmse)


# More detailed performance measures --------------------------------------

cat("Let's look at xgboost performance in more detail...")

learner <- mlr::makeLearner("regr.xgboost")

m <- mlr::train(learner = learner, task = task)

predTrain <- predict(m, task = task)
cat("Performance measures MSE, MEDSE, MAE and RMSE...")
cat(performance(predTrain, measures = list(mse, medse, mae, rmse)))


# Hyper parameter tuning --------------------------------------------------

cat("Hyper parameter tuning for xgboost...")

# Discrete search space for the number of rounds
discrete_ps = makeParamSet(
  makeDiscreteParam("nrounds", values = c(1,100,500))
)
discrete_ps

ctrl = makeTuneControlGrid()

res = tuneParams("regr.xgboost", task = task, resampling = rdesc,
                 par.set = discrete_ps, control = ctrl, measures = rmse)

cat("It seems as performance can be dramatically improved just by increasing the number of nrounds, we use that as our first shot...")


