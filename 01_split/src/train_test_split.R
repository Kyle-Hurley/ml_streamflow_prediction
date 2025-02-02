train_test_split <- function(main_data) {
  
  # Conduct A roughly 70/30 train/test split
  # Due to covid, climate data was not collected
  # 2020-06-03 through 2022-08-15
  last_day <- as.Date("2020-06-02")
  starts_again <- as.Date("2022-08-16")
  # n_datum <- nrow(main_data)
  # train_index <- floor(n_datum * 0.7)
  # test_index <- train_index + 1
  
  train_set <- main_data[main_data$date <= last_day, ]
  test_set <- main_data[main_data$date >= starts_again, ]
  train_test <- list(
    train_set = train_set, 
    test_set = test_set
  )
  return(train_test)
  
}