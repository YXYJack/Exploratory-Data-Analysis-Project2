## Compare emissions from motor vehicle sources in Baltimore City with
## emissions from motor vehicle sources in Los Angeles County, California
## (fips == "06037"). Which city has seen greater changes over time in 
## motor vehicle emissions?

packages=c("plyr","dplyr","sqldf","lubridate","ggplot2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

## This .R script assumes "NEI_data.zip" is unzipped in the working directory

setwd("C://Users/Mark/Desktop/datascience/Exploratory Data/Exploratory Data Analysis Project2")        
N <- "summarySCC_PM25.rds"
S <- "Source_Classification_Code.rds"

##load the  data into data tables
if(!exists("NEI")){
        NEI <- readRDS(N)
        SCC <- readRDS(S)
}
## subset needed data for total PM2.5 by year for all motor-vehicle sources
SCC.subset<-SCC[,c(1:3)]
NEI.1 <- NEI[NEI$fips=="24510"|NEI$fips=="06037", ]  ##temp df to hold Baltimore- and LA-only data

if(!exists("NEI.names")){  ##this is system-intensive, so only run if needed
        NEI.names<-merge(NEI.1,SCC.subset,by="SCC")
        PM.BM.LA<-NEI.names[grep("^On-road",NEI.names$type,ignore.case=T),]  
        ## Here we assume "motor vehicles" are all NEI$type=="ON-ROAD"
}

##temp <- xtabs(Emissions~year+type,PM.BM) #this is a temporary variable for cross-checking

## plot
png(filename="plot6.png",width = 480, height = 480, units = "px",res=72)
p <- ggplot(PM.BM.LA, aes(year))
p <- p + geom_histogram(binwidth=1,aes(weight=Emissions,fill=factor(fips,labels=c("a","b"))),
                                       position="dodge")
p <- p + labs(fill = "City (based on fips value)")
p <- p + scale_x_continuous(breaks=c(1999,2002,2005,2008))
p <- p + scale_fill_discrete(labels=c("Los Angeles, CA","Baltimore, MD"))
p <- p + ggtitle("Total PM2.5 Emissions from Motor Vehicle-related Sources \nfor Baltimore, MD vs Los Angeles, CA, by Year")
p <- p + ylab("PM2.5 Emissions in Tons")
print(p)
on.exit(dev.off())

## Results: 
## The annual total emissions from motor vehicle sources in Baltimore City,MD
## vary wildly compared to emissions from motor vehicle sources in 
## Los Angeles County, CA.  In Baltimore, over the period 1999-2008, PM2.5 
## emissions fell from 1999-2002, flat in 2002-2005 and fell from 2005 to 2008
## with PM2.5 emissions in 2008 ending much lower than 1999.
## In Los Angeles, over the period 1999-2008, PM2.5 
## emissions increased from 1999-2002, increased again in 2002-2005 and 
## fell from 2005 to 2008, with PM2.5 totals only slightly below
## the 1999 value.