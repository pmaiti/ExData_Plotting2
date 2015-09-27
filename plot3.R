## Prabir Maiti

## Goals for this project

##1.Loading the data
##2.Making plots. 

## first set the file path and working directory here
## setwd("C:\DataScience\4-ExploratoryDataAnalysis\WorkingDirectory")
workingDirectory<-getwd()
	
## all folder names
baseDataFolder <- 'EPA_National_Emission_Data'

## download all data files and unzip those
if (!file.exists(baseDataFolder)) {
	dir.create(file.path(workingDirectory, baseDataFolder), showWarnings = FALSE)

	fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
	zipFile = paste(workingDirectory, "/", baseDataFolder, "/EPA_National_Emission_Data.zip", sep="")
	extractDir = paste(workingDirectory, "/", baseDataFolder,sep="")
	setInternet2(TRUE)
	download.file(fileUrl, destfile = zipFile)
	unzip(zipfile = zipFile, overwrite = TRUE, exdir = extractDir)
}

## create file paths for NEI and SCC
filePathNEI <- paste(workingDirectory, "/", baseDataFolder, "/summarySCC_PM25.rds", sep="")
filePathSCC <- paste(workingDirectory, "/", baseDataFolder, "/Source_Classification_Code.rds", sep="")

## read the files
dataNEI <- readRDS(file = filePathNEI)
dataSCC <- readRDS(file = filePathSCC)

## load library (dplyr) and library(ggplo2)
library(dplyr)
library(ggplot2)

## find total emissions by year for Balimore City, Maryland
dataBaltimore <- filter(dataNEI, fips == "24510")
mergeBaltimore <- merge(dataBaltimore, dataSCC, by.x="SCC", by.y="SCC")
filterBaltimore <- filter(mergeBaltimore, !(Data.Category == "Event"))
yearsAndCategory <- group_by(filterBaltimore, year, Data.Category)
totalEmissionsByYear <- summarize(yearsAndCategory, totalEmissions = sum(Emissions, na.rm = TRUE))

## create a plot function and save a .png
plot3 <- function() {

	## open the .png device here
	png("plot3.png", width=1000, height=480)
	
	## create the plot here
	g <- ggplot(totalEmissionsByYear, aes(x=year, y=totalEmissions)) + ylim(0, 3000) + geom_line() + facet_grid(. ~ Data.Category) 
	g <- g + theme_bw() + labs(title = "Emissions between 1999 and 2008 for Baltimore City by Category") + labs(x = "Year", y = "Emissions")
	
	print(g)
	
	## release the graphic device
	dev.off()
	cat("Plot3.png has been saved in", getwd())
}
plot3()