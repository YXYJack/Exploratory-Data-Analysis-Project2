## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
##(fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot 
##answering this question.

packages=c("plyr","dplyr","sqldf","lubridate")
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

## subset needed data for total PM2.5 by year in Baltimore only
PM.year<-aggregate(Emissions ~ year, NEI[NEI$fips=="24510", ], sum)
PM.year$year<-strptime(as.character(PM.year$year),"%Y") ## sets years as Dates
YR<-unique(NEI$year)

#plot graph to file
png(filename="plot2.png",width = 480, height = 480, units = "px",res=72)
plot(PM.year$year,PM.year$Emissions,type = "p",
     main = "Total Recorded PM2.5 Emissions From All Sources \nin Baltimore,MD (fips=24510) by Year",
     ylab="PM2.5 in tons",
     xlab="Year",
     xaxt='n')
lines(PM.year$year,PM.year$Emissions)
axis.POSIXct(1,at=PM.year$year,labels=format(PM.year$year,"%Y"))
box()
dev.off()

## Results: Emissions of PM2.5 (all sources) in Baltimore fell 1999-2002,
## increased from 2002-2005 and fell from 2002-2005.