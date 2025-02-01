source("00_dl_preprocess/src/get_streamflow.R")
source("00_dl_preprocess/src/get_climate_data.R")

t00a_all_data <- list(
  tar_target(
    streamflow_data, 
    get_streamflow(
      site_numbers = site_no, 
      start_date = q_st_date, end_date = q_end_date
    )
  ), 
  tar_target(
    climate_data, 
    get_climate_data(
      url = msc_clim_data_link
    )
  )
)