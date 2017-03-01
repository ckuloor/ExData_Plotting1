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

# plot global active power as a function of dataDate field as line chart with the given x and y axis labels.
plot(Global_active_power ~ dataDate, data=filteredConsumption, type="l", xlab="", ylab="Global Active Power (kilowatts)")

#Save the plot toa png file
dev.copy(png, file="Plot2.png",width=480,height=480)

#close the device
dev.off()