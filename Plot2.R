# Plot2.R
# Creates the plot from the provided data to create the plot2.png output

library(data.table)
library(dplyr)

# Define Parameters for Assignment; 
data.zip <- "./data/exdata_data_household_power_consumption.zip"
minDate="2007-02-01"
maxDate="2007-02-02"
input.date.format="%d/%m/%Y"
input.time.format="%H:%M:%S"

# Execute Script to generate Plot1.png:
if (file.exists(data.zip)){
  tryCatch({
    temp.data <- unzip(data.zip)
    temp.data <- data.table::fread(temp.data)
    
    # Convert values to DateTimes, and filter data for min/max date range: 
    temp.data$Date <- as.Date(temp.data$Date, format=input.date.format)
    trimmed.data <- temp.data %>% filter(Date>=as.Date(minDate) & Date<= as.Date(maxDate))
    
    # Create datetime field for later use: 
    trimmed.data$datetime <- paste0(trimmed.data$Date, trimmed.data$Time)
    trimmed.data$datetime <- as.POSIXct(trimmed.data$datetime)
    
    # Open the png graphics device: 
    png(filename="plot2.png")
    
    # Create the second plot (plot2.png) as a line plot of global active power
    # As a function of weekday/time
    
    plot(trimmed.data$datetime, trimmed.data$Global_active_power, type="l",
         xlab="", ylab="Global Active Power (kilowatts)")
    
    # Close the graphics device:
    dev.off()
    
  }, error=function(e){
    print(paste0("Unable to generate Plot2.png due to: ",e))
  })
} else {
  print('Unable to generate Plot2.png...data.zip does not exist')
}