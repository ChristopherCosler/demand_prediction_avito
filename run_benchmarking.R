
# This script is used for benchmarking a several algorithms using mlr
# The most promising package is further investigated via hyperparameter tuning
# It runs on a smaller sample set and does not handle it very memory efficient as mlr needs a data frame
# For the actual preditions, use the other run scripts that use the full dataset
# The actual prediction scripts are highly memory efficient

# Configure ---------------------------------------------------------------

# How many rows of the data to read from the train and test datasets
nTrainData <- 2e5
nTestData <- 100 # must be >= 100 for the script to work


# Run ---------------------------------------------------------------------

source("0_setup.R")
source("1_data.R")
source("2_text.R")
source("3_benchmarking_mlr.R")
