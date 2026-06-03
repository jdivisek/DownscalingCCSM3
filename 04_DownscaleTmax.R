###DOWNSCALE MONTHLY MAXIMUM TEMPERATURE-------------------------------------------------------------

library(raster)
library(rgdal)
library(fields)
library(RSAGA)
library(geosphere)
library(stringr)

source("./Functions/getAvgPoints.R")

n <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")

rasterOptions(tmpdir=paste0(getwd(), "/temp"))

##Upscale CHELSA data to 2.5 degrees resolution--------------------------------------------------
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmax"), pattern='sdat', full.names=TRUE )
ch.paths <- ch.paths[str_detect(ch.paths, pattern = ".sdat.", negate = T)]

for(i in seq(1, length(ch.paths)))
{
  print(paste(month.name[i], "*********************************************************************************************"))
  
  #aggregate data to 2.5 degrees resolution
  cat("", "\n", "Aggregating to 2.5° resolution", "\n")
  ch <- raster(ch.paths[i], native=T)
  ch.agr <- aggregate(ch, fact=300, fun=mean, expland=F, na.rm=T, progress="text")#aggregate to 2.5 degrees - CCSM3 resolution
  
  writeRaster(ch.agr, paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmax/tmax", n[i], "avg.tif"), "GTiff")
  
  #remove temporary files
  rm(ch, ch.agr)
  file.remove(list.files(paste0(getwd(), "/temp"), full.names = T))
}

##Load CCSM3 simulations for period 1940-1989 AD (centered on 1965)
m1965.paths <- c(paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/01_Jan/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/02_Feb/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/03_Mar/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/04_Apr/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/05_May/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/06_Jun/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/07_Jul/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/08_Aug/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/09_Sep/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/10_Oct/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/11_Nov/grid_data_1965AD.txt"),
                 paste0(getwd(), "/paleodata_months_Europe/tmax/1940-1989/12_Dec/grid_data_1965AD.txt"))

o1965.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmax"), pattern='tif', full.names=TRUE)

##Create bias files---------------------------------------------------------------------------------
for(i in 1:12)
{
  print(i)
  
  m1965 <- read.table(m1965.paths[i], header = F, dec = ".")
  m1965 <- raster(as.matrix(m1965[4:23,60:100]))
  extent(m1965) <- extent(c(-32.5,70,32.5,82.5))
  projection(m1965) <- CRS("+proj=longlat +datum=WGS84")
  # plot(m1965, main = "Model")
  
  o1965 <- raster(o1965.paths[i])
  # plot(o1965, main = "Observed")
  
  bias <- o1965-m1965
  # plot(bias, main = "Bias")
  
  # plot(m1965+bias, main = "Model + bias")
  # plot(o1965, main = "Observed")
  
  writeRaster(bias, paste0(getwd(), "/GIS_database/bias_files/", "bias_tmax", n[i], ".tif"), "GTiff")
}

bias <- stack(list.files(path= paste0(getwd(), "/GIS_database/bias_files/tmax"), pattern='tif', full.names=TRUE))
projection(bias) <- CRS("+proj=longlat +datum=WGS84")
plot(bias, main=month.name)

###DEBIASING AND DOWSCALING CCSM3 SIMULATIONS--------------------------------------------------------------------
m.paths <- list()
m.paths[[1]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/01_Jan"), pattern='txt', full.names=TRUE)
m.paths[[2]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/02_Feb"), pattern='txt', full.names=TRUE)
m.paths[[3]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/03_Mar"), pattern='txt', full.names=TRUE)
m.paths[[4]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/04_Apr"), pattern='txt', full.names=TRUE)
m.paths[[5]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/05_May"), pattern='txt', full.names=TRUE)
m.paths[[6]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/06_Jun"), pattern='txt', full.names=TRUE)
m.paths[[7]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/07_Jul"), pattern='txt', full.names=TRUE)
m.paths[[8]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/08_Aug"), pattern='txt', full.names=TRUE)
m.paths[[9]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/09_Sep"), pattern='txt', full.names=TRUE)
m.paths[[10]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/10_Oct"), pattern='txt', full.names=TRUE)
m.paths[[11]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/11_Nov"), pattern='txt', full.names=TRUE)
m.paths[[12]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmax/12_Dec"), pattern='txt', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  m.paths[[i]] <- m.paths[[i]][-c(length(m.paths[[i]]))]
  tw <- as.numeric(unlist(lapply(regmatches(m.paths[[i]], gregexpr("[[:digit:]]+", m.paths[[i]])), FUN=function(x){x[length(x)]})))
  m.paths[[i]] <- m.paths[[i]][order(tw)]
}
tw <- sort(tw)

#load upscaled chelsa rasters
obs <- stack(list.files(path= paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmax"), pattern='tif', full.names=TRUE))
projection(obs) <- CRS("+proj=longlat +datum=WGS84")
plot(obs, main=month.name)

#paths to fine-scale chelsa rasters
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmax"), pattern='sgrd', full.names=TRUE)

#create target directories
for(q in seq(1, 12))
{
  dir.create(path = paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/", 
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
    print(paste("****************************", month.name[q], "mean temperature for", tw[i], "BP ****************************", sep= " "))
    
    mod <- read.table(m.paths[[q]][i], header = F, dec = ".")#read PaleoView output
    mod <- raster(as.matrix(mod[4:23,60:100])) #select region 32.5W - 70E, 82.5N-32.5N
    extent(mod) <- extent(c(-32.5,70,32.5,82.5)) #set extent
    projection(mod) <- CRS("+proj=longlat +datum=WGS84") #set coordinate system
    # plot(mod, main = "Model")
    
    #correct model (account for differences between model and observed data in 1940-1989)
    mod <- mod+bias[[q]]
    # plot(mod, main = "Model + bias")
    
    #create delta layer
    # plot(obs[[q]], main = "Observed")
    d <- mod-obs[[q]]
    # plot(d, main = "Anomaly (delta)")
    
    #extract anomalies to average points
    avg.points$delta <- extract(d, avg.points[, c("X", "Y")])
    
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
    rsaga.geoprocessor("grid_calculus", 8, list(GRIDS=paste0(c(ch.paths[q], "delta_spline.sgrd"), collapse = "; "), 
                                                RESULT= "downscaled.sgrd"), env=saga.env, show.output.on.console=F)
    
    filename <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/", 
                       n[q], "_", month.abb[q], "/tmax", n[q], "_", tw[i], "BP", ".tif")
    
    #compress data and save as GeoTiff
    cat("", "\n", paste0("Saving...", month.name[q], "mean temperature for", tw[i], "BP", sep=" "), "\n")
    rsaga.geoprocessor("io_gdal", 2, list(GRIDS="downscaled.sgrd", FILE=filename, 
                                          OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
    cat("", "\n", paste0("Done... file size is", round(file.size(filename)/1000000,1), "MB", sep=" "), "\n")
    
    ##remove temporary files
    cat("", "\n", "Removing temporary files...", "\n")
    file.remove(list.files(saga.env$workspace, pattern="delta", full.names = T))
    file.remove(list.files(saga.env$workspace, pattern="downscaled", full.names = T))
    
  }
  
}
Sys.time()
