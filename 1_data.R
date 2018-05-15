

# Load data ---------------------------------------------------------------

cat("Load data...  \n")

train <- readr::read_csv("./data/train.csv", n_max = nTrainData, progress = TRUE)
test <- readr::read_csv("./data/test.csv", n_max = nTestData, progress = TRUE)


# Wrangle data ------------------------------------------------------------

cat("Wrangle test and train data at the same time...  \n")

# Save label in another file and id
y <- train$deal_probability
item_id <- test$item_id

train_test <- train %>% 
  dplyr::select(-deal_probability) %>% 
  bind_rows(test) %>% 
  mutate(no_img = image %>% is.na() %>% as.integer(),
         no_dsc = description %>% is.na() %>% as.integer(),
         no_p1 = param_1 %>% is.na() %>% as.integer(), 
         no_p2 = param_2 %>% is.na() %>% as.integer(), 
         no_p3 = param_3 %>% is.na() %>% as.integer(),
         titl_len = str_length(title),
         desc_len = str_length(description),
         titl_cap = str_count(title, "[A-ZА-Я]"),
         desc_cap = str_count(description, "[A-ZА-Я]"),
         titl_pun = str_count(title, "[[:punct:]]"),
         desc_pun = str_count(description, "[[:punct:]]"),
         titl_dig = str_count(title, "[[:digit:]]"),
         desc_dig = str_count(description, "[[:digit:]]"),
         user_type = as.numeric(as.factor(user_type)),
         category_name = category_name %>% factor() %>% as.integer(),
         parent_category_name = parent_category_name %>% factor() %>% as.integer(), 
         region = region %>% factor() %>% as.integer(),
         param_1 = param_1 %>% factor() %>% as.integer(),
         param_2 = param_2 %>% factor() %>% as.integer(),
         param_3 = param_3 %>% factor() %>% fct_lump(prop = 0.00005) %>% as.integer(),
         city = city %>% factor() %>% fct_lump(prop = 0.0003) %>% as.integer(),
         user_id = user_id %>% factor() %>% fct_lump(prop = 0.000025) %>% as.integer(),
         price = log1p(price),
         txt = paste(title, description, sep = " "),
         mday = mday(activation_date),
         wday = wday(activation_date),         
         day = day(activation_date)) %>% 
  dplyr::select(-item_id, -image, -title, -description, -activation_date) %>% 
  replace_na(list(image_top_1 = -1, price = -1, 
                  param_1 = -1, param_2 = -1, param_3 = -1,
                  desc_len = 0, desc_cap = 0, desc_pun = 0, desc_dig = 0)) %T>% 
  glimpse()

rm(train, test); gc() # clean up after yourself