source("00_dl_preprocess/src/create_predictors.R")
source("00_dl_preprocess/src/decimal_year.R")

t00b_processed_data <- list(
  tar_target(
    predictor_data, 
    create_predictors(
      climate_data = climate_data, 
      sf_dates = streamflow_data$date
    )
  ), 
  tar_target(
    main_data, 
    {
      df <- merge(streamflow_data, predictor_data)
      return(df)
    }
  )
)
