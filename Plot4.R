# Check if the downloaded file already exists, if not download and unzip to the current wd.
if(!file.exists("PowerConsumption.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "PowerConsumption.zip")
  unzip("PowerConsumption.zip")
}
## check if the sqldf package is installed, if not install it
if("sqldf" %in% rownames(installed.packages()) == FALSE) {
  install.packages("sqldf")
}
# load the sqldf lib
library(sqldf)

options(warn=-1)

#read the energy consumption data for only Feb/1/2007 and Feb/2/2007
filteredConsumption <- read.csv.sql("household_power_consumption.txt", sep=';',sql="select * from file where Date=\'1/2/2007\' OR Date=\'2/2/2007\'", eol="\n")

#close connections
closeAllConnections()
options(warn=0)

# create a new column by combining the Date and Time columns
filteredConsumption$dataDate <- with(filteredConsumption, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))

#define a 2 X 2 grid for adding multiple plots. It will be column fill grid.
par(mfcol=c(2,2))

#Plot 1
plot(Global_active_power ~ dataDate, data=filteredConsumption, type="l", xlab="", ylab="Global Active Power")

#Plot 2
plot(Sub_metering_1 ~ dataDate, data=filteredConsumption, type="l", xlab="", ylab="Energy sub metering")
lines(Sub_metering_2 ~ dataDate, data=filteredConsumption, type="l", col="red")
lines(Sub_metering_3 ~ dataDate, data=filteredConsumption, type="l", col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),lty=c(1,1,1), col=c("black","red","blue"))

#Plot 3
plot(Voltage ~ dataDate, data=filteredConsumption, type="l", xlab="datetime", ylab="Voltage")

#Plot 4
plot(Global_reactive_power ~ dataDate, data=filteredConsumption, type="l", xlab="datetime")

#Save the file to a png file
dev.copy(png, file="Plot4.png",width=480,height=480)

#close the device
dev.off()

