# demand_prediction_avito
Predict demand for a product based on its description and photo

Based on the Avito Kaggle challenge https://www.kaggle.com/c/avito-demand-prediction

The challenge includes text descriptions of the products as well as some properties of the internet listing. There are also images associated with some listing, but I do not use these currently.

## Main challenges

- features have to be extracted from title and descriptions and are the only meaningful predictors
- language is Russian and letters are cyrillic
- more than 1e6 listings with long text descriptions demand for memory efficient coding
- most outcomes of the training examples are 0

## File structure

    ├── 0_setup.R                     # Prepare your R session
    ├── 1_data.R                      # Load data and initial wrangling
    ├── 2_text.R                      # Prepare text with word2vec and tfidf
    ├── 3_benchmarking_mlr.R          # Compare algorithms using mlr wrappers
    ├── 4_xgboost.R                   # Create submission using xgboost
    ├── 5_neural_net.R                # Create submission using neural net
    ├── run_benchmarking.R            # Source the benchmarking scripts
    ├── run_xgboost.R                 # Source the xgboost scripts
    ├── run_neural_net.R              # Source the neural net scripts
    ├── data
      ├── empty                      # Kaggle does not allow to share this
    ├── submissions
      ├── empty                      # Kaggle does not allow to share this
      
## Tools used

- R
- text analysis with word2vec and tf-idf
- mlr package to benchmark several machine learning algorithms that have worked well on similar problems
- eXtreme Gradient Boosting for the submission data set

## Feature Extractation

The most relevant information is hidden in the listings' titles and description, which are in cyrillic. I clean the strings, tokenize and build a dictionary using the word stems. Tf-idf is used to determine the importance of the words in the corpus. The most relevant are used as predictors.

## run_benchmarking.R

In the benchmarking, several algorithms are tested, including
- Generalised Linear Regression,
- eXtreme Gradient Boosting,
- Gradient Boosting,
- Extreme Learning Machine for Single Hidden Layer Feedforward Neural Networks,
- Fast k-Nearest Neighbor.

For this, only part of the data is used.

## run_xgboost.R

So far, eXtreme Gradient Boosting shows the most promising results and is thus further explored using hyperparameter tuning in run_benchmarking. Here, all of the data is used, which makes it necessary to work with sparce matrices and code in a memory efficient way.

## run_neural_net.R

Neural net also looks promising. Not yet as good as xgboost but there is still some hypeparameter tuning left that could improve. Looks promising.


## Next steps

- include images in the script
- more hyperparameter tuning
- handle excess 0's (maybe by using a binary classifier first?)
