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

## search for motor related SCC for LA and BA
dataEmissionLAandBA <- dataNEI[dataNEI$fips=="24510"|dataNEI$fips=="06037",]
indexVehicle <- which( grepl("Highway Veh",dataSCC[,"Short.Name"]) ) 
dataSCCVehicle <- dataSCC[indexVehicle,]

## get data for vehcile and caculate total emission in Baltimore and LA
dataVehicleEmissionLAandBA <- dataEmissionLAandBA[which(dataEmissionLAandBA$SCC %in% dataSCCVehicle$SCC),]
totalVehicleEmissionLAandBA <- with(dataVehicleEmissionLAandBA, tapply(Emissions,list(fips,year),sum))

rownames(totalVehicleEmissionLAandBA)[which(rownames(totalVehicleEmissionLAandBA)=="06037")] <- "Los Angeles"
rownames(totalVehicleEmissionLAandBA)[which(rownames(totalVehicleEmissionLAandBA)=="24510")] <- "Baltimore"

changesMotorEmissionLAvsBA <- matrix(NA, nrow=nrow(totalVehicleEmissionLAandBA),ncol=ncol(totalVehicleEmissionLAandBA))
colnames(changesMotorEmissionLAvsBA) <- colnames(totalVehicleEmissionLAandBA)
rownames(changesMotorEmissionLAvsBA) <- rownames(totalVehicleEmissionLAandBA)

changesMotorEmissionLAvsBA[1,] <- log10(totalVehicleEmissionLAandBA[1,]/totalVehicleEmissionLAandBA[1,1])*100
changesMotorEmissionLAvsBA[2,] <- log10(totalVehicleEmissionLAandBA[2,]/totalVehicleEmissionLAandBA[2,1])*100

print("Emission Changes in %")
print(changesMotorEmissionLAvsBA)

temp <- as.vector(changesMotorEmissionLAvsBA)
n <- nrow(changesMotorEmissionLAvsBA)
temp_year <- rep(years,each=n)
temp_city <- rep(rownames(changesMotorEmissionLAvsBA),times=n)
changesMotorEmissionLAvsBA <- data.frame(ChangeInEmission = temp,Year=temp_year,City=temp_city)

print("Emission Changes in %")
print(changesMotorEmissionLAvsBA)

library(ggplot2)

## create a plot function and save a .png
plot6 <- function() {

	## open the .png device here
	png("plot6.png", width=1000, height=480)
	
	## create the plot here
	g <- ggplot(changesMotorEmissionLAvsBA, aes(x=Year, y=ChangeInEmission)) + geom_line() + facet_grid(City~.) 
	g <- g + theme_bw() + labs(title = "Emissions Change in % - Los Angles vs. Baltimore") + labs(x = "Year", y = "Change in Emissions %")
	
	print(g)
	
	## release the graphic device
	dev.off()
	cat("Plot6.png has been saved in", getwd())
}
plot6()
