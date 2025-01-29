get_climate_data <- function(url) {
  
  temp_file <- tempfile("climate_data", fileext = ".csv")
  on.exit(unlink(temp_file))
  
  dl_success <- download.file(
    url = url, destfile = temp_file, 
    quiet = TRUE
  )
  
  if (dl_success != 0) stop("Failed to download climate data from ", url)
  
  climate_data <- read.csv(temp_file)
  
  return(climate_data)
  
}