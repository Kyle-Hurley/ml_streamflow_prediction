# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c("dataRetrieval")
)

# Set site number and temporal extent to query
site_no <- "01585219"
q_st_date <- "2013-10-01"
q_end_date <- "2024-12-31"


# Set link to the MD Science Center climate data csv
msc_clim_data_link <- "https://www.ncei.noaa.gov/data/daily-summaries/access/USW00093784.csv"

# Run the targets
source("00a_download_data.R")
source("00b_preprocess_data.R")

# Return the targets
c(t00a_all_data, t00b_processed_data)
