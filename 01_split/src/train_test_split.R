train_test_split <- function(main_data) {
  
  # Conduct 70/30 train/test split
  # Simple chronological split
  n_datum <- nrow(main_data)
  train_index <- floor(n_datum * 0.7)
  test_index <- train_index + 1
  
  train_set <- main_data[1:train_index, ]
  test_set <- main_data[test_index:n_datum, ]
  train_test <- list(
    train_set = train_set, 
    test_set = test_set
  )
  return(train_test)
  
}