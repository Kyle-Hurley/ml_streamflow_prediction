source("01_split/src/train_test_split.R")

t01_train_test <- list(
  tar_target(
    train_test, 
    train_test_split(main_data)
  )
)