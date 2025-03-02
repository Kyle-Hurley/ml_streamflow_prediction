build_and_tune <- function(train_test, grid = 10) {
  
  # Ideally, these steps would be performed after a predictor selection algorithm
  #   that defines which predictors are most useful when estimating the model(s).
  
  # Create recipe
  discharge_rec <- recipes::recipe(q_cfs ~ ., data = train_test$train_set) |> 
    # Set role for date column and exclude as a predictor
    recipes::update_role(date, new_role = "date") |> 
    # Minimal rows with NA values; remove these; else errors
    recipes::step_naomit(recipes::all_predictors(), skip = TRUE)
  
  # Set model specifications
  # Generalized linear model
  lr_mod <- parsnip::linear_reg(
    penalty = hardhat::tune(), 
    mixture = hardhat::tune()
  ) |> 
    parsnip::set_engine("glmnet")
  
  # Multivariate Adaptive Regression Splines
  mars_mod <- parsnip::mars(
    num_terms = hardhat::tune(), 
    prod_degree = hardhat::tune()
  ) |> 
    parsnip::set_engine("earth") |> 
    parsnip::set_mode("regression")
  
  # Boosted Regression Tree
  boost_tree_mod <- parsnip::boost_tree(
    mtry = hardhat::tune(), 
    trees = hardhat::tune(), 
    min_n = hardhat::tune(), 
    tree_depth = hardhat::tune(), 
    learn_rate = hardhat::tune(), 
    loss_reduction = hardhat::tune()
  ) |> 
    parsnip::set_engine("lightgbm") |> 
    parsnip::set_mode("regression")
  
  # Aggregate a set of workflows based on the recipe and model specs
  workflow_set <- workflowsets::workflow_set(
    list(discharge_rec), 
    list(
      lrm = lr_mod, 
      marsm = mars_mod, 
      btm = boost_tree_mod
    )
  )
  
  # Create resamples with 2yr/1yr train/test split
  resamples <- rsample::sliding_period(
    train_test$train_set, 
    date, "year", lookback = 1, assess_stop = 1
  )
  
  # Set a future for parallel processing
  future::plan("sequential")
  
  # Tune hyperparameters
  tuning <- workflowsets::workflow_map(
    workflow_set,
    "tune_race_anova",
    resamples = resamples,
    grid = grid,
    metrics = yardstick::metric_set(
      yardstick::rmse, yardstick::mae, yardstick::rsq, yardstick::ccc
    ),
    control = finetune::control_race(save_pred = TRUE, save_workflow = TRUE)
  )
  
  return(tuning)
  
}

