## Across the United States, how have emissions from coal 
##combustion-related sources changed from 1999-2008?

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

## subset needed data for total PM2.5 by year for all coal-related sources
SCC.subset<-SCC[,c(1,3,4)]
if(!exists("NEI.names")){  ##this is system-intensive, so only run if needed
        NEI.names<-merge(NEI,SCC.subset,by="SCC")
        PM.coal<-NEI.names[grep("Coal|Lignite",NEI.names$Short.Name),]  ##Match using Short.Name
}

##temp <- xtabs(Emissions~year+type,PM.coal) #this is a temporary variable for cross-checking

## plot
png(filename="plot4.png",width = 480, height = 480, units = "px",res=72)
p <- ggplot(PM.coal, aes(year))
p <- p + geom_histogram(binwidth=1,aes(weight=Emissions/1000,fill=type),
                        position="dodge")
p <- p + theme(legend.position = "none") ##supress color legend
p <- p + facet_wrap(~type)
p <- p + scale_x_continuous(breaks=c(1999,2002,2005,2008))
p <- p + ggtitle("Total PM2.5 Emissions from Coal Combustion-related Sources \nfor USA, by Year and Type")
p <- p + ylab("PM2.5 Emissions in kilotons")
print(p)
on.exit(dev.off())

## Results: according to the NEI dataset, total USA-wide PM2.5 emissions from coal
## combustion-related sources (excluding charcoal, which is not coal) acted as follows:
## emissions from NEI-classified "point" sources fell consistently from 1998 to 2002
## increased slightly from 2002 to 2005, then fell from 2005 to 2008.
## Emissions from NEI-classified "nonpoint" sources grew significantly from 
## 1999 to 2002, held steady in 2005, then fell dramatically by/in 2008.