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

## find total emissions by year in the US
years <- unique(dataNEI$year)
totalEmissionsByYear <- tapply(dataNEI$Emissions,dataNEI$year,sum)

## create a plot function and save a .png
plot1 <- function() {
	## open the .png device here
	png("plot1.png", width=1000, height=480)
	
	## create and save a .png
	plot(totalEmissionsByYear,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions in the U.S")
	axis(side=1,labels=as.character(years),at=1:length(years))

	##with(totalEmissionsByYear, plot(year, totalEmissions, type="l", xlab = "Year", ylab = expression("Total" ~ PM[2.5] ~"Emissions (tons)"), main = expression("Total US" ~ PM[2.5] ~ "Emissions by Year"), col="Purple"))
	##with(totalEmissionsByYear, plot(year, totalEmissions, main = "Total Emissions in the US by Year", xlab = "Year", ylab = "Total Emissions", pch=20))
	
	## release the graphic device
	dev.off()
	cat("Plot1.png has been saved in", getwd())
}
plot1()