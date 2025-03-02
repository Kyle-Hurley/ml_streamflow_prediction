# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c(
    "dataRetrieval", "stats", "tidymodels", "lightgbm", "bonsai", 
    "hardhat", "earth", "glmnet", "future", "finetune", "stacks"
  )
)

# Set site number and temporal extent to query
site_no <- "01585219"
q_st_date <- "2013-10-01"
q_end_date <- "2024-12-31"


# Set link to the MD Science Center climate data csv
# Climate data is missing 2020-06-03 through 2022-08-15; likely due to covid
msc_clim_data_link <- "https://www.ncei.noaa.gov/data/daily-summaries/access/USW00093784.csv"

# Set size of grid
# A larger grid provides more hyperparameter combinations, but increases
# computation time as well.
grid <- 20

# Run the targets
source("00_dl_preprocess/00a_download_data.R")
source("00_dl_preprocess/00b_preprocess_data.R")
source("01_split/01_train_test_split.R")
source("02_build/02_build_and_train.R")

# Return the targets
c(
  # Download streamflow & climate data
  t00a_all_data, 
  # Create predictor data and merge with streamflow data
  t00b_processed_data, 
  # Split into train/test set
  t01_train_test, 
  # Build and tune the models
  # Models include: 
  # Generalized Linear Model, Multivariate Adaptive Regression Splines, and 
  # Boosted Tree Regression
  t02_built_models
)
