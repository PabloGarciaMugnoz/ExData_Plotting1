# Plot 4
# In this script four different plots are stored in the same file, we keep 
# working this some features used in the previous plots.
# function parameters
#     fromfile,       date to start extracting measurement
#     numberofdays,   number of days ahead to extract measurements

plot4 <- function(fromdate ="1/2/2007", numberofdays = 2) {

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
studydata <- fread("household_power_consumption.txt", 
                   sep=";", 
                   skip = fromdate,
                   nrows = numberofrows,
                   stringsAsFactors=F,
                   na.strings=c("?",""),                    
                   colClasses = c("character", "character", rep("numeric",7)))

# Extract columns names.
setnames(studydata,colnames(fread("household_power_consumption.txt",nrows = 0)))

# Convert character date and time character varibles to time/date classes
studydata$Time <- as.POSIXct(strptime(paste( studydata$Date,studydata$Time),
                                      "%d/%m/%Y %H:%M:%S" ))

studydata$Date <- as.Date(studydata$Date, "%d/%m/%Y")


# Open png device connection
png("plot4.png")

# Generating the plot, it contains 4 subplot
par(mfcol = c(2, 2))
with(studydata, {
    # Subplot 1
    with(studydata, plot(Time, Global_active_power,
                        type="l",
                        ylab = "Global Active Power (kilowatts)",
                        xlab =""))
    # subplot 2
    with(studydata,plot(Time, Sub_metering_1,
                        type="l",
                        ylab = "Energy sub metering",
                        xlab =""))
    # Adding two more lines
    with(studydata, lines(Time, Sub_metering_2, col = "red"))
    with(studydata, lines(Time, Sub_metering_3, col = "blue"))
    legend("topright", lty = 1, col = c("black", "blue", "red"),bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

    # Subplot 3
    with(studydata,plot(Time, Voltage, type = "l",
                        xlab = "datetime", 
                        ylab = "Voltage"))
    # Subplot 4
    with(studydata,plot(Time, Global_reactive_power,
                        type = "l",
                        xlab = "datetime",
                        ylab = "Voltage"))
})

# Closing connection with png device
dev.off()
 
# End of file reached
return("OK")
   
}