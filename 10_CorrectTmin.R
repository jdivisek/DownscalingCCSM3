###CORRECT EXTREME ANOMALIES IN MONTHLY MAXIMUM TEMPERATURE-------------------------------------------------------------
#Here, extreme anomalies identified in the prevous step are corrected
#by excluding these values from interpolation

library(raster)
library(rgdal)
library(fields)
library(RSAGA)
library(geosphere)
library(stringr)
library(rstatix)

source("./Functions/getAvgPoints.R")

n <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")

###load bias layers
bias <- stack(list.files(path= paste0(getwd(), "/bias_files/tmin"), pattern='tif', full.names=TRUE))
projection(bias) <- CRS("+proj=longlat +datum=WGS84")
plot(bias, main=month.name)

###DEBIASING AND DOWSCALING CCSM3 SIMULATIONS--------------------------------------------------------------------
m.paths <- list()
m.paths[[1]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/01_Jan"), pattern='txt', full.names=TRUE)
m.paths[[2]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/02_Feb"), pattern='txt', full.names=TRUE)
m.paths[[3]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/03_Mar"), pattern='txt', full.names=TRUE)
m.paths[[4]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/04_Apr"), pattern='txt', full.names=TRUE)
m.paths[[5]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/05_May"), pattern='txt', full.names=TRUE)
m.paths[[6]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/06_Jun"), pattern='txt', full.names=TRUE)
m.paths[[7]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/07_Jul"), pattern='txt', full.names=TRUE)
m.paths[[8]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/08_Aug"), pattern='txt', full.names=TRUE)
m.paths[[9]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/09_Sep"), pattern='txt', full.names=TRUE)
m.paths[[10]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/10_Oct"), pattern='txt', full.names=TRUE)
m.paths[[11]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/11_Nov"), pattern='txt', full.names=TRUE)
m.paths[[12]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmin/12_Dec"), pattern='txt', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  m.paths[[i]] <- m.paths[[i]][-c(length(m.paths[[i]]))]
  tw <- as.numeric(unlist(lapply(regmatches(m.paths[[i]], gregexpr("[[:digit:]]+", m.paths[[i]])), FUN=function(x){x[length(x)]})))
  m.paths[[i]] <- m.paths[[i]][order(tw)]
}
tw <- sort(tw)
tw

#load upscaled chelsa rasters
obs <- stack(list.files(path= paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmin"), pattern='tif', full.names=TRUE))
projection(obs) <- CRS("+proj=longlat +datum=WGS84")
plot(obs, main=month.name)

#paths to fine-scale chelsa rasters
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmin"), pattern='sgrd', full.names=TRUE)

#create target directories
for(q in seq(1, 12))
{
  dir.create(path = paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/", 
                           n[q], "_", month.abb[q]))
}

saga.env <- rsaga.env()
saga.env$workspace <- paste0(getwd(), "/temp")
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env
rasterOptions(tmpdir=saga.env$workspace)

for(q in 1:12)##loop for 12 months
{
  print(paste("*******************************", month.name[q], "*******************************", sep= " "))
  
  ##find cells closest to avegage
  chelsa <- raster(gsub("sgrd", "sdat", ch.paths[q]), native=T)
  projection(chelsa) <- CRS("+proj=longlat +datum=WGS84")
  avg.points <- getAvgPoints(r=chelsa, fact=300, fact2=30, res=2.5, ext=extent(c(-32.5,70,32.5,82.5)), fun=mean)
  removeTmpFiles(0)
  # plot(bias[[q]], main="Points for interpolation")
  # points(avg.points, pch=3)
  
  for(i in seq(1,length(m.paths[[q]]))) #loop for each time window over the last 21 000 years #
  {
    if(length(tmin.ext[[q]][[i]]) > 0)
    {
      print(paste("*******",month.name[q], "minimum temperature for", tw[i], "BP *******", sep= " "))
      
      mod <- read.table(m.paths[[q]][i], header = F, sep="", dec = ".")#read PaleoView output
      mod <- raster(as.matrix(mod[4:23,60:100])) #select region 32.5W - 70E, 82.5N-32.5N
      extent(mod) <- extent(c(-32.5,70,32.5,82.5)) #set extent
      projection(mod) <- CRS("+proj=longlat +datum=WGS84") #set coordinate system
      # plot(mod, main = "Model")
      
      #correct model (account for differences between model and observed data in 1980-1989)
      mod <- mod+bias[[q]]
      # plot(mod, main = "Model + bias")
      
      #create delta layer
      # plot(obs[[q]], main = "Observed")
      d <- mod-obs[[q]]
      # plot(d, main = "Anomaly (delta)")
      
      ##CHECK EXTREME ANOMALIES
      dev <- abs(values(d) - median(values(d)))
      d[rank(dev) > 779 & is_extreme(values(d))] <- NA
      # plot(d, main = "Anomaly (delta) - No extremes")
      
      #extract anomalies to average points
      avg.points$delta <- raster::extract(d, avg.points[, c("X", "Y")])
      
      sp <- SpatialPointsDataFrame(avg.points[, c("X", "Y")], avg.points, proj4string=CRS(projection(chelsa)))
      # plot(sp, add=T)
      
      writeOGR(sp, saga.env$workspace, "delta_points", driver = "ESRI Shapefile")
      
      rm(mod, d, sp)
      
      # rsaga.get.modules("grid_spline", env = saga.env)
      # rsaga.get.usage("grid_spline",4, env = saga.env)
      
      cat("", "\n", "Interpolating anomalies...", "\n")
      rsaga.geoprocessor("grid_spline", 4, list(SHAPES="delta_points.shp", FIELD="delta", TARGET_DEFINITION="1", 
                                                TARGET_TEMPLATE=ch.paths[q], 
                                                TARGET_OUT_GRID="delta_spline.sgrd", LEVEL_MAX=14), env=saga.env, show.output.on.console=F)
      
      #add anomalies
      cat("", "\n", "Adding interpolated anomalies...", "\n")
      rsaga.geoprocessor("grid_calculus", 8, list(GRIDS=paste0(c(ch.paths[[q]], "delta_spline.sgrd"), collapse = "; "), 
                                                  RESULT= "downscaled.sgrd"), env=saga.env, show.output.on.console=F)
      
      filename <- paste0(getwd(),"/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/", 
                         n[q], "_", month.abb[q], "/tmin", n[q], "_", tw[i], "BP", ".tif")
      
      #compress data and save as GeoTiff
      cat("", "\n", paste0("Saving...", month.name[q], "minimum temperature for", tw[i], "BP", sep=" "), "\n")
      rsaga.geoprocessor("io_gdal", 2, list(GRIDS="downscaled.sgrd", FILE=filename, 
                                            OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
      cat("", "\n", paste0("Done... file size is", round(file.size(filename)/1000000,1), "MB", sep=" "), "\n")
      
      ##remove temporary files
      cat("", "\n", "Removing temporary files...", "\n")
      file.remove(list.files(saga.env$workspace, pattern="delta", full.names = T))
      file.remove(list.files(saga.env$workspace, pattern="downscaled", full.names = T))
      
    }
  }
}
Sys.time()
