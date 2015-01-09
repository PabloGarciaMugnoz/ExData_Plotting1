# Plot 2
# In this script we generate a line plot.
# function parameters
#     fromfile,       date to start extracting measurement
#     numberofdays,   number of days ahead to extract measurements

plot2 <- function(fromdate ="1/2/2007", numberofdays = 2) {
    
# include packages    
require(data.table) 

# set english as default language
Sys.setlocale("LC_TIME", "English")

# First check for file, if not downloaded do it.
# file is stored on working directory, name not changed
if (!file.exists("household_power_consumption.txt")){
    message("Downloading data")
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  "exdata_data_household_power_consumption.zip")
    unzip("exdata_data_household_power_consumption.zip")
}

# Extracting only data for required days
# number of rows equals minutes per day multiplied by number of days 1440. 
numberofrows = 1440*numberofdays

# Read the data
dtpowerconsumption <- fread("household_power_consumption.txt", 
                   sep=";", 
                   skip = fromdate,
                   nrows = numberofrows,
                   stringsAsFactors=F,
                   na.strings=c("?",""),                    
                   colClasses = c("character", "character", rep("numeric",7)))

# Extract columns names.
setnames(dtpowerconsumption,colnames(fread("household_power_consumption.txt",nrows = 0)))

# Convert character date and time character varibles to time/date classes
dtpowerconsumption$Time <- as.POSIXct(strptime(paste( dtpowerconsumption$Date,dtpowerconsumption$Time),
                                      "%d/%m/%Y %H:%M:%S" ))

dtpowerconsumption$Date <- as.Date(dtpowerconsumption$Date, "%d/%m/%Y")

# Open png device connection
png("plot2.png")

    # Generating the plot
    with(dtpowerconsumption,plot(Time, Global_active_power,
                        type="l",
                        xlab ="",
                        ylab = "Global Active Power (kilowatts)"))
                 
# Closing connection with png device
dev.off()

# End of file reached
return("OK")

}
