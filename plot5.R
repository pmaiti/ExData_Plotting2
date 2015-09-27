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

## unique years
years <- unique(dataNEI$year)

## search for motor related SCC
dataBaltimore <- dataNEI[dataNEI$fips=="24510",]
indexVehicle <- which( grepl("Highway Veh",dataSCC[,"Short.Name"]) ) 
dataSCCVehicle <- dataSCC[indexVehicle,]

## get data for vehcile and caculate total emission in Baltimore
dataBaltimoreVehicleEmission <- dataBaltimore[which(dataBaltimore$SCC %in% dataSCCVehicle$SCC),]
totalBaltimoreVehicleEmission <- tapply(dataBaltimoreVehicleEmission$Emissions,dataBaltimoreVehicleEmission$year,sum)

## create a plot function and save a .png
plot5 <- function() {

	## open the .png device here
	png("plot5.png", width=1000, height=480)
	
	## create the plot here
	plot(totalBaltimoreVehicleEmission,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions from motor vehicle in Baltimore City")
	axis(side=1,labels=as.character(years),at=1:length(years))
	
	## release the graphic device
	dev.off()
	cat("Plot5.png has been saved in", getwd())
}
plot5()