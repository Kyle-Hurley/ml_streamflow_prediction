decimal_year <- function(date) {
  
  # Convert to date-time class
  date_time <- as.POSIXlt(date)
  year <- date_time$year + 1900
  
  # Indicate start and end of years
  start_year <- as.POSIXct(
    paste0(year, "-01-01 00:00")
  )
  end_year <- as.POSIXct(
    paste0(year + 1, "-01-01 00:00")
  )
  
  # Takes the form:
  # (date_time - start_year) / (length of year)
  dec_year <- year + 
    as.numeric(
      difftime(date_time, start_year, units = "secs")
    ) / 
    as.numeric(
      difftime(end_year, start_year, units = "secs")
    )
  
  return(dec_year)
  
}
