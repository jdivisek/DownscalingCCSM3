###PPREPARE BASELINE CLIMATE DATA-------------------------------------------------------------
##Create 50-yrs average based on CHELSA Timeseries and CHELSAcrtuts datasets
library(RSAGA)
library(raster)
library(stringr)

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env
saga.env$workspace <- paste0(getwd(), "/temp")

rsaga.get.libraries(path = saga.env$modules)
rsaga.get.modules("io_gdal", env = saga.env)
rsaga.get.usage("grid_calculus", 1, env = saga.env)

###AVERAGE CHELSAcruts TMIN AND TMAX-----------------------------------------------------------------------------------
tmin.paths <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmin"), full.names = T)
names(tmin.paths) <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmin"), full.names = F)
tmax.paths <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmax"), full.names = T)
names(tmax.paths) <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmax"), full.names = F)

for(i in seq(1, length(tmin.paths)))
{
  print(i)
  
  #copy files
  file.copy(tmin.paths[i], saga.env$workspace)
  file.copy(tmax.paths[i], saga.env$workspace)
  
  #extract names
  filenames <- c(names(tmin.paths)[i], names(tmax.paths)[i])
  
  #calculate average
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste0(c(filenames, "land.mask.sgrd"), collapse = "; "), 
                                              RESULT="tmean.sgrd", 
                                              FORMULA="((g1 + g2)/2)*g3", NAME="tmean"), env=saga.env, show.output.on.console=F)
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="tmean.sgrd", FILE=gsub("tmin", "tmean", filenames[1]), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", gsub("tmin", "tmean", filenames[1])), paste0(getwd(), "/GIS_database/CHELSAcruts/1940-1950/tmean/"))
  
  #remove temporary files
  file.remove(list.files(saga.env$workspace, pattern="tmean", full.names = T))
  file.remove(list.files(saga.env$workspace, pattern="tif", full.names = T))
  
}
Sys.time()

###CONVERT CHELSA TIMESERIES FROM KELVIN TO C*10-------------------------------------------------------
##Mean monthly temperature-------------------------------------------------------------------------------------
tmean.paths <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmean"), full.names = T)
names(tmean.paths) <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmean"), full.names = F)

for(i in seq(1, length(tmean.paths)))
{
  print(i)
  
  #copy files
  file.copy(tmean.paths[i], saga.env$workspace)
  
  #extract names
  filename <- names(tmean.paths)[i]
  
  #calculate average
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=filename, 
                                              RESULT="celsius.sgrd", 
                                              FORMULA="((g1 /10) + (-273.15))*10", NAME="tmean"), env=saga.env, show.output.on.console=F)
  
  file.remove(paste0(saga.env$workspace, "/", filename))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="celsius.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmeanC"))
  
  #remove temporary files
  file.remove(list.files(saga.env$workspace, pattern="celsius", full.names = T))
  file.remove(list.files(saga.env$workspace, pattern="tif", full.names = T))
  
}
Sys.time()

##Maximum monthly temperature-------------------------------------------------------------------------------------
tmax.paths <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmax"), full.names = T)
names(tmax.paths) <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmax"), full.names = F)

for(i in seq(1, length(tmax.paths)))
{
  print(i)
  
  #copy files
  file.copy(tmax.paths[i], saga.env$workspace)
  
  #extract names
  filename <- names(tmax.paths)[i]
  
  #calculate average
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=filename, 
                                              RESULT="celsius.sgrd", 
                                              FORMULA="((g1 /10) + (-273.15))*10", NAME="tmax"), env=saga.env, show.output.on.console=F)
  
  file.remove(paste0(saga.env$workspace, "/", filename))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="celsius.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmaxC"))
  
  #remove temporary files
  file.remove(list.files(saga.env$workspace, pattern="celsius", full.names = T))
  file.remove(list.files(saga.env$workspace, pattern="tif", full.names = T))
  
}
Sys.time()

##Minimum monthly temperature-------------------------------------------------------------------------------------
tmin.paths <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmin"), full.names = T)
names(tmin.paths) <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmin"), full.names = F)

for(i in seq(1, length(tmin.paths)))
{
  print(i)
  
  #copy files
  file.copy(tmin.paths[i], saga.env$workspace)
  
  #extract names
  filename <- names(tmin.paths)[i]
  
  #calculate average
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=filename, 
                                              RESULT="celsius.sgrd", 
                                              FORMULA="((g1 /10) + (-273.15))*10", NAME="tmin"), env=saga.env, show.output.on.console=F)
  
  file.remove(paste0(saga.env$workspace, "/", filename))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="celsius.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA Timeseries/tminC"))
  
  #remove temporary files
  file.remove(list.files(saga.env$workspace, pattern="celsius", full.names = T))
  file.remove(list.files(saga.env$workspace, pattern="tif", full.names = T))
  
}
Sys.time()



####CALCULATE 50 YRS AVERAGE-----------------------------------------------------------------------------------

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env
saga.env$workspace <- paste0(getwd(), "/temp")

# rsaga.get.libraries(path = saga.env$modules)
# rsaga.get.modules("statistics_grid", env = saga.env)
# rsaga.get.usage("statistics_grid", 4, env = saga.env)


n <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")


###Mean monthly temperature------------------------------------------------------------------------------------------
for(i in 1:12)
{
  print(i)
  
  ###load data
  CHELSAcruts <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmean"), full.names = T)
  CHELSAcruts <- CHELSAcruts[ str_detect(CHELSAcruts, paste0("_", i, "_"))]
  
  CHELSAts <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmeanC"), full.names = T)
  CHELSAts <- CHELSAts[ str_detect(CHELSAts, paste0("_", n[i], "_"))]
  
  tmean.paths <- c(CHELSAcruts, CHELSAts)
  rm(CHELSAts, CHELSAcruts)
  
  ##create filename
  filename <- paste0("CHELSA_1940-1989_tmean", n[i], ".tif")
  
  ##calculate 50 yrs mean
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste0(tmean.paths, collapse = "; "), 
                                                MEAN="mean50.sgrd"), env=saga.env, show.output.on.console=F)
  
  ##divide by 10
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="mean50.sgrd", RESULT ="tmean.sgrd" ,
                                              FORMULA="g1/10", NAME="tmean"), env=saga.env, show.output.on.console=F)
  
  #remove mean50
  file.remove(list.files(saga.env$workspace, pattern="mean50", full.names = T))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="tmean.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA 1940-1989/tmean"))
  
  #remove files
  file.remove(list.files(saga.env$workspace, pattern="tmean", full.names = T))
  
}
Sys.time()

###Maximum monthly temperature------------------------------------------------------------------------------------------
###For MAX and MIN temperatures, resulting rasters must be multiplied by land mask becasue origial chelsa rasters (tif) have
##wrong NAvalue tag
for(i in 1:12)
{
  print(i)
  
  ###load data
  CHELSAcruts <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmax"),  full.names = T)
  CHELSAcruts <- CHELSAcruts[ str_detect(CHELSAcruts, paste0("_", i, "_"))]
  
  CHELSAts <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tmaxC"), full.names = T)
  CHELSAts <- CHELSAts[ str_detect(CHELSAts, paste0("_", n[i], "_"))]
  
  tmax.paths <- c(CHELSAcruts, CHELSAts)
  rm(CHELSAts, CHELSAcruts)
  
  ##create filename
  filename <- paste0("CHELSA_1940-1989_tmax", n[i], ".tif")
  
  ##calculate 50 yrs mean
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste0(tmax.paths, collapse = "; "), 
                                                MEAN="mean50.sgrd"), env=saga.env, show.output.on.console=F)
  
  ##divide by 10
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="mean50.sgrd; mask.land.sgrd", RESULT ="tmax.sgrd" ,
                                              FORMULA="(g1*g6)/10", NAME="tmax"), env=saga.env, show.output.on.console=F)
  
  #remove mean50
  file.remove(list.files(saga.env$workspace, pattern="mean50", full.names = T))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="tmax.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA 1940-1989/tmax"))
  
  #remove files
  file.remove(list.files(saga.env$workspace, pattern="tmax", full.names = T))
  
}
Sys.time()

###Minimum monthly temperature------------------------------------------------------------------------------------------
###For MAX and MIN temperatures, resulting rasters must be multiplied by land mask becasue origial chelsa rasters (tif) have
##wrong NAvalue tag
for(i in 1:12)
{
  print(i)
  
  ###load data
  CHELSAcruts <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/tmin"),  full.names = T)
  CHELSAcruts <- CHELSAcruts[ str_detect(CHELSAcruts, paste0("_", i, "_"))]
  
  CHELSAts <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/tminC"), full.names = T)
  CHELSAts <- CHELSAts[ str_detect(CHELSAts, paste0("_", n[i], "_"))]
  
  tmin.paths <- c(CHELSAcruts, CHELSAts)
  rm(CHELSAts, CHELSAcruts)
  
  ##create filename
  filename <- paste0("CHELSA_1940-1989_tmin", n[i], ".tif")
  
  ##calculate 50 yrs mean
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste0(tmin.paths, collapse = "; "), 
                                                MEAN="mean50.sgrd"), env=saga.env, show.output.on.console=F)
  
  ##divide by 10
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="mean50.sgrd; mask.land.sgrd", RESULT ="tmin.sgrd" ,
                                              FORMULA="(g1*g6)/10", NAME="tmin"), env=saga.env, show.output.on.console=F)
  
  #remove mean50
  file.remove(list.files(saga.env$workspace, pattern="mean50", full.names = T))
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="tmin.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA 1940-1989/tmin"))
  
  #remove files
  file.remove(list.files(saga.env$workspace, pattern="tmin", full.names = T))
  
}
Sys.time()

###Monthly precipitation------------------------------------------------------------------------------------------
for(i in 1:12)
{
  print(i)
  
  ###load data
  CHELSAcruts <- list.files(paste0(getwd(), "/GIS_database/CHELSAcruts/prec"), full.names = T)
  CHELSAcruts <- CHELSAcruts[ str_detect(CHELSAcruts, paste0("_", i, "_"))]
  
  CHELSAts <- list.files(paste0(getwd(), "/GIS_database/CHELSA Timeseries/prec"), full.names = T)
  CHELSAts <- CHELSAts[ str_detect(CHELSAts, paste0("_", n[i], "_"))]
  
  prec.paths <- c(CHELSAcruts, CHELSAts)
  rm(CHELSAts, CHELSAcruts)
  
  ##create filename
  filename <- paste0("CHELSA_1940-1989_prec", n[i], ".tif")
  
  ##calculate 50 yrs mean
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste0(prec.paths, collapse = "; "), 
                                                MEAN="prec.sgrd"), env=saga.env, show.output.on.console=F)
  
  #save as tif file
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS="prec.sgrd", FILE=filename, 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  #copy to GIS database
  file.copy(paste0(saga.env$workspace, "/", filename), paste0(getwd(), "/GIS_database/CHELSA 1940-1989/prec"))
  
  #remove files
  file.remove(list.files(saga.env$workspace, pattern="prec", full.names = T))
  
}
Sys.time()
