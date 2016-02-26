## How have emissions from motor vehicle sources changed from 1999-2008
##in Baltimore City?

packages=c("plyr","dplyr","sqldf","lubridate","ggplot2")
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
## subset needed data for total PM2.5 by year for all motor-vehicle sources
SCC.subset<-SCC[,c(1:3)]
NEI.1 <- NEI[NEI$fips=="24510", ]  ##temp df to hold Baltimore-only data

if(!exists("NEI.names")){  ##this is system-intensive, so only run if needed
        NEI.names<-merge(NEI.1,SCC.subset,by="SCC")
        PM.BM<-NEI.names[grep("^On-road",NEI.names$type,ignore.case=T),]  
        ## Here we assume "motor vehicles" are all NEI$type=="ON-ROAD"
}

##temp <- xtabs(Emissions~year+type,PM.BM) #this is a temporary variable for cross-checking

## plot
png(filename="plot5.png",width = 480, height = 480, units = "px",res=72)
p <- ggplot(PM.BM, aes(year))
p <- p + geom_histogram(binwidth=1,aes(weight=Emissions),position="dodge")
p <- p + facet_wrap(~type)
p <- p + scale_x_continuous(breaks=c(1999,2002,2005,2008))
p <- p + ggtitle("Total PM2.5 Emissions from Motor Vehicle-related Sources \nfor Baltimore, MD, by Year and Type")
p <- p + ylab("PM2.5 Emissions in Tons")
print(p)
on.exit(dev.off())

## Results: Emissions from motor-vehicle sources (assumed to be NEI$type=="ON-ROAD")
## acted as follows:emissions fell sharply from 1998 to 2002, fell slightly from 2002-2005
## then fell again from 2005 to 2008.
