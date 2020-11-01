# Plot3.R
# Creates the plot from the provided data to create the plot3.png output

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
    png(filename="plot3.png")
    
    # Create the second plot (plot3.png) as a line plot showing the three sub-
    # meterings as a function of time
    
    plot(trimmed.data$datetime, trimmed.data$Sub_metering_1, type="l",
         xlab="", ylab="Energy sub metering")
    lines(trimmed.data$datetime, trimmed.data$Sub_metering_2, type="l",
          col="red")
    lines(trimmed.data$datetime, trimmed.data$Sub_metering_3, type="l",
          col="blue")
    legend("topright",legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
           col=c('black','red','blue'), lwd=1)
    
    # Close the graphics device:
    dev.copy(png,"plot3.png", width=480, height=480)
    dev.off()
    
  }, error=function(e){
    print(paste0("Unable to generate Plot3.png due to: ",e))
  })
} else {
  print('Unable to generate Plot3.png...data.zip does not exist')
}