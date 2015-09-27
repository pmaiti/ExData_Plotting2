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

## load librar (dplyr)
library(dplyr)

## find total emissions by year for Balimore City, Maryland
dataBaltimore <- filter(dataNEI, fips == "24510")
years <- group_by(dataBaltimore, year)
totalEmissionsByYear <- summarize(years, totalEmissions = sum(Emissions, na.rm = TRUE))

## create a plot function and save a .png
plot2 <- function() {

	## open the .png device here
	png("plot2.png", width=1000, height=480)
	
	## create the plot here
	with(totalEmissionsByYear, plot(year, totalEmissions, type="l", main = "Total Emissions by Year from PM2.5 for Baltimore City, Maryland", xlab = "Year", ylab = "Total Emissions", pch=20))
	
	## release the graphic device
	dev.off()
	cat("Plot2.png has been saved in", getwd())
}
plot2()