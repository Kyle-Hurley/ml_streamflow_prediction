get_streamflow <- function(site_numbers, start_date = "", end_date = "") {
  
  streamflow <- dataRetrieval::readNWISdv(
    siteNumbers = site_numbers, 
    parameterCd = "00060", 
    startDate = start_date, 
    endDate = end_date, 
    statCd = "00003"
  )
  
  streamflow <- streamflow[, c(3, 4)]
  colnames(streamflow) <- c("date", "q_cfs")
  
  return(streamflow)
  
}