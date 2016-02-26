## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
##variable, which of these four sources have seen decreases in emissions from 1999-2008
##for Baltimore City? Which have seen increases in emissions from 1999-2008? 
##Use the ggplot2 plotting system to make a plot answer this question.

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

## subset needed data for total PM2.5 by year in Baltimore
PM.BM<-NEI[NEI$fips=="24510",]
PM.BM$type<-as.factor(PM.BM$type)

##temp<-xtabs(Emissions~year+type,PM.BM) #this is a temporary variable for cross-checking

## plot
png(filename="plot3.png",width = 480, height = 480, units = "px",res=72)
p <- ggplot(PM.BM, aes(year))
p <- p + geom_histogram(binwidth=1,aes(weight=Emissions,fill=type),position="dodge")
p <- p + theme(legend.position = "none") ##supress color legend
p <- p + facet_wrap(~type)
p <- p + scale_x_continuous(breaks=c(1999,2002,2005,2008))
p <- p + ggtitle("Total PM2.5 Emissions for Baltimore, MD by Year and Type")
p <- p + ylab("PM2.5 Emissions in Tons")
print(p)
dev.off()

## Results: In Baltimore, MB across 1999,2002,2005,2008 the following changes occurred
## in PM2.5 total emissions:
## Non-road emissions fell
## On-road emission fell
## Non-point emissions fell
## Point emissions grew sharply 1999-2002, then fell sharply 2002-2005