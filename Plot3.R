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

# plot the first series with the given labels
plot(Sub_metering_1 ~ dataDate, data=filteredConsumption, type="l", xlab="", ylab="Energy sub metering")

# add Sub_metering_2 and Sub_metering_3 series to the plot with red and blue colors
lines(Sub_metering_2 ~ dataDate, data=filteredConsumption, type="l", col="red")
lines(Sub_metering_3 ~ dataDate, data=filteredConsumption, type="l", col="blue")

#add a legend on the top right corner
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),lty=c(1,1,1), col=c("black","red","blue"))

#save the plot to a png file
dev.copy(png, file="Plot3.png",width=480,height=480)

#close the device
dev.off()

