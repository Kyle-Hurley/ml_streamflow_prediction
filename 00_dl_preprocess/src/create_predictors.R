create_predictors <- function(climate_data, sf_dates) {
  
  climate_data$DATE <- as.Date(climate_data$DATE)
  columns <- c(
    "DATE", "PRCP", "SNOW", "SNWD", "TMAX", "TMIN"
  )
  predictors <- climate_data[, columns]
  colnames(predictors) <- tolower(columns)
  
  predictors <- predictors[predictors$date %in% sf_dates, ]
  
  predictors$tavg <- (predictors$tmax + predictors$tmin) / 2
  
  predictors <- predictors[order(predictors$date), ]
  
  cols <- c("tmax", "tmin", "tavg", "prcp")
  rollmean_vals <- vector("list", length = 4)
  names(rollmean_vals) <- cols
  for (col in cols) {
    rollmean_vals[[col]] <- lapply(
      X = c(
        as.difftime(2, units = "days"),
        as.difftime(4, units = "days"),
        as.difftime(6, units = "days")
      ),
      FUN = \(z) {
        slider::slide_index_dbl(
          .x = predictors[, col],
          .i = as.Date(predictors$date),
          .f = ~mean(.x, na.rm = TRUE),
          .before = z,
          .after = 0
        )
      }
    )
    
    predictors[, paste0(col, "_roll_2")] <- rollmean_vals[[col]][[1]]
    predictors[, paste0(col, "_roll_4")] <- rollmean_vals[[col]][[2]]
    predictors[, paste0(col, "_roll_6")] <- rollmean_vals[[col]][[3]]
  }
  
  # Account for seasonality
  # Map dates to the unit circle
  # Allows for model to learn the timing and intensity of seasons
  dec_year <- decimal_year(predictors$date)
  predictors$sin_date <- sin(2*pi*dec_year)
  predictors$cos_date <- cos(2*pi*dec_year)
  
  return(predictors)
}
