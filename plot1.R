## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
##Using the base plotting system, make a plot showing the total PM2.5 emission from 
##all sources for each of the years 1999, 2002, 2005, and 2008.

ackages=c("plyr","dplyr","sqldf","lubridate")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
## This .R script assumes "NEI_data.zip" is unzipped in the working directory

setwd("C://Users/Mark/Desktop/datascience/Exploratory Data/Exploratory Data Analysis Project2")        
N<-"summarySCC_PM25.rds"
S<-"Source_Classification_Code.rds"

##load the  data into data tables
if(!exists("NEI")){
        NEI <- readRDS(N)
        SCC <- readRDS(S)
}

## subset needed data for total PM2.5 by year for all USA
PM.year <- aggregate(Emissions ~ year, NEI, sum)
PM.year$year<-strptime(as.character(PM.year$year),"%Y") ## sets years as Dates

#plot graph to file
png(filename="plot1.png",width = 480, height = 480, units = "px",res=72)
plot(PM.year$year,PM.year$Emissions/1000,
     type = "p",
     main = "Total Recorded PM2.5 Emissions From All Sources USA-Wide",
     ylab="PM2.5 Emissions in kilotons",
     xlab="Year",
     xaxt='n')  ## supress auto-generated X-axis ticks                
lines(PM.year$year,PM.year$Emissions/1000)
axis.POSIXct(1,at=PM.year$year,labels=format(PM.year$year,"%Y"))
box()
on.exit(dev.off()) ##on.exit closes the device if execution is stopped

## Results: Emissions of PM2.5 (all sources) across the USA fell  1998-2008
