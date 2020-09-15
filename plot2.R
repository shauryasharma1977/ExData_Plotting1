library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(sqldf)


## select statement to retrieve records 
## for the 1st and 2nd Feb 2017
sqlStmt <- paste("select * from file",
                 "where Date = '1/2/2007' or Date='2/2/2007'" )

## use sqldf to only get the requireddata  
## than to loading the entire dataset
hpc <- sqldf::read.csv.sql("./data/household_power_consumption.txt",
                           sql = sqlStmt , sep=";")


## Convert to  desired variable types
## Combine Date and TIme into a New variable
hpc$DateTime<-paste(hpc$Date, hpc$Time)
hpc$DateTime <- strptime(hpc$DateTime, "%d/%m/%Y %H:%M:%S")
hpc$DateTime <- as.POSIXct(hpc$DateTime)
## Drop Data and Time from the data set 
hpc<-hpc[, -(1:2)]
hpc$Global_active_power <- as.numeric(hpc$Global_active_power)
hpc$Global_reactive_power <- as.numeric(hpc$Global_reactive_power)
hpc$Voltage <- as.numeric(hpc$Voltage)
hpc$Global_intensity <- as.numeric(hpc$Global_intensity)
hpc$Sub_metering_1 <- as.numeric(hpc$Sub_metering_1)
hpc$Sub_metering_2 <- as.numeric(hpc$Sub_metering_2)
hpc$Sub_metering_3 <- as.numeric(hpc$Sub_metering_3)

## Plot a graph with X- Axis = DateTime and y - Axis = Active Power
plot(hpc$Global_active_power~hpc$DateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")

## create png file and store to the working directory 
## close graphics device
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()

