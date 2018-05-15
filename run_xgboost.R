# This script performs training for xgboost, based on benchmarking results and hyperparameter tuning
# in run_benchmarking.R

# It uses sparse matrices and can thus handle the whole dataset even on smaller machines
# The data wrangling scripts are shared with run_benchmarking.R however

# The output can be found in "./submissions/..."

# Configure ---------------------------------------------------------------

# How many rows of the data to read from the train and test datasets
nTrainData <- 1e10
nTestData <- 1e10 # this must be >= obs in test data to be a valid submission


# Run ---------------------------------------------------------------------

source("0_setup.R")
source("1_data.R")
source("2_text.R")
source("4_xgboost.R")