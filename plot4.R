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

## search for rows with coals
years <- unique(dataNEI$year)

indexCoal <- which( grepl("coal",dataSCC[,"Short.Name"]) ) 
indexCoal2 <- which( grepl("Coal",dataSCC[,"Short.Name"]) ) 
allCoalIndex <- unique (sort (c(indexCoal,indexCoal2)))
dataSCCCoal <- dataSCC[allCoalIndex,]

## get data for coal and caculate total emission
dataNEICoal <- dataNEI[which(dataNEI$SCC %in% dataSCCCoal$SCC),]
totalNEICoal <- tapply(dataNEICoal$Emissions,dataNEICoal$year,sum)

## create a plot function and save a .png
plot4 <- function() {

	## open the .png device here
	png("plot4.png", width=1000, height=480)
	
	## create the plot here

	plot(totalNEICoal,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions from coal combustion-related sources")
	axis(side=1,labels=as.character(years),at=1:length(years))
	
	## release the graphic device
	dev.off()
	cat("Plot4.png has been saved in", getwd())
}
plot4()