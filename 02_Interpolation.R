###INTERPOLATE TEMPERATURES AND PRECIPITATION IN AREAS CURRENTLY UNDER THE SEA LEVEL-------------------------------------------------------
library(raster)
library(rgdal)
library(RSAGA)
library(stringr)

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env
saga.env$workspace <- paste0(getwd(), "/temp")

# rsaga.get.libraries(path = saga.env$modules)
# rsaga.get.modules("grid_tools", env = saga.env)
# rsaga.get.usage("grid_spline",5, env = saga.env)

n <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")

mask.land <- paste0(getwd(), "/dem/mask_1940-1989.sgrd") #land mask for current period with valoue of 1 for land areas

###MEAN MONTHLY TEMPERATURE---------------------------------------------------------------------------------------
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/tmean/"), pattern='sgrd', full.names=TRUE )

for(i in 1:12)
{
  print(paste(month.name[i], "************************************************************************************"))
  
  nm <- unlist(lapply(str_split(ch.paths, "/"), FUN=function(x){x[length(x)]}))[i]
  
  #Spline interpolation
  cat("", "\n", "Multilevel B-spline interpolation...", "\n")
  rsaga.geoprocessor("grid_spline", 5, list(GRID=ch.paths[i], TARGET_DEFINITION="1", TARGET_TEMPLATE=ch.paths[i],
                                            TARGET_OUT_GRID="spline.sgrd", LEVEL_MAX=14), env=saga.env)
  
  cat("", "\n", "Saving result...", "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(mask.land, ch.paths[i], "spline.sgrd"), collapse = "; "), 
                                              RESULT=nm,
                                              FORMULA="ifelse(g1 = 1, g2, g3)", USE_NODATA="1"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=nm, FILE=gsub("sgrd", "tif", nm), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console = F)
  
  #copy to GIS database
  file.copy(from = list.files(saga.env$workspace, pattern = "tif", full.names = T), 
            to = paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmean"))
  
  cat("", "\n", "Removing temporary files...", "\n")
  file.remove(list.files(saga.env$workspace, pattern = gsub(".sgrd", "", nm), full.names = T))
  file.remove(list.files(saga.env$workspace, pattern = "spline", full.names = T))
}

###MIN MONTHLY TEMPERATURE---------------------------------------------------------------------------------------
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/tmin/"), pattern='sgrd', full.names=TRUE )

for(i in 1:12)
{
  print(paste(month.name[i], "************************************************************************************"))
  
  nm <- unlist(lapply(str_split(ch.paths, "/"), FUN=function(x){x[length(x)]}))[i]
  
  #Spline interpolation
  cat("", "\n", "Multilevel B-spline interpolation...", "\n")
  rsaga.geoprocessor("grid_spline", 5, list(GRID=ch.paths[i], TARGET_DEFINITION="1", TARGET_TEMPLATE=ch.paths[i],
                                            TARGET_OUT_GRID="spline.sgrd", LEVEL_MAX=14), env=saga.env)
  
  cat("", "\n", "Saving result...", "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(mask.land, ch.paths[i], "spline.sgrd"), collapse = "; "), 
                                              RESULT=nm,
                                              FORMULA="ifelse(g1 = 1, g2, g3)", USE_NODATA="1"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=nm, FILE=gsub("sgrd", "tif", nm), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console = F)
  
  #copy to GIS database
  file.copy(from = list.files(saga.env$workspace, pattern = "tif", full.names = T), 
            to = paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmin"))
  
  cat("", "\n", "Removing temporary files...", "\n")
  file.remove(list.files(saga.env$workspace, pattern = gsub(".sgrd", "", nm), full.names = T))
  file.remove(list.files(saga.env$workspace, pattern = "spline", full.names = T))
}

###MAX MONTHLY TEMPERATURE---------------------------------------------------------------------------------------
ch.paths <- list.files(path= "//ha-bay.ics.muni.cz/Homes/Shared/vegsci/GIS_database/CHELSA 1940-1989/tmax/", pattern='sgrd', full.names=TRUE )

for(i in 1:12)
{
  print(paste(month.name[i], "************************************************************************************"))
  
  nm <- unlist(lapply(str_split(ch.paths, "/"), FUN=function(x){x[length(x)]}))[i]
  
  #Spline interpolation
  cat("", "\n", "Multilevel B-spline interpolation...", "\n")
  rsaga.geoprocessor("grid_spline", 5, list(GRID=ch.paths[i], TARGET_DEFINITION="1", TARGET_TEMPLATE=ch.paths[i],
                                            TARGET_OUT_GRID="spline.sgrd", LEVEL_MAX=14), env=saga.env)
  
  cat("", "\n", "Saving result...", "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(mask.land, ch.paths[i], "spline.sgrd"), collapse = "; "), 
                                              RESULT=nm,
                                              FORMULA="ifelse(g1 = 1, g2, g3)", USE_NODATA="1"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=nm, FILE=gsub("sgrd", "tif", nm), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console = F)
  
  #copy to GIS database
  file.copy(from = list.files(saga.env$workspace, pattern = "tif", full.names = T), 
            to = paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmax"))
  
  cat("", "\n", "Removing temporary files...", "\n")
  file.remove(list.files(saga.env$workspace, pattern = gsub(".sgrd", "", nm), full.names = T))
  file.remove(list.files(saga.env$workspace, pattern = "spline", full.names = T))
}

###PRECIPITATION---------------------------------------------------------------------------------------
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/prec/"), pattern='sgrd', full.names=TRUE )

for(i in 1:12)
{
  print(paste(month.name[i], "************************************************************************************"))
  
  nm <- unlist(lapply(str_split(ch.paths, "/"), FUN=function(x){x[length(x)]}))[i]
  
  #Spline interpolation
  cat("", "\n", "Multilevel B-spline interpolation...", "\n")
  rsaga.geoprocessor("grid_spline", 5, list(GRID=ch.paths[i], TARGET_DEFINITION="1", TARGET_TEMPLATE=ch.paths[i],
                                            TARGET_OUT_GRID="spline.sgrd", LEVEL_MAX=14), env=saga.env)
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="spline.sgrd", RESULT="spline_corrected.sgrd",
                                              FORMULA="ifelse(g1 < 0, 0, g1)"), env=saga.env, show.output.on.console=F)
  
  cat("", "\n", "Saving result...", "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(mask.land, ch.paths[i], "spline_corrected.sgrd"), collapse = "; "), 
                                              RESULT=nm,
                                              FORMULA="ifelse(g1 = 1, g2, g3)", USE_NODATA="1"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=nm, FILE=gsub("sgrd", "tif", nm), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console = F)
  
  #copy to GIS database
  file.copy(from = list.files(saga.env$workspace, pattern = "tif", full.names = T), 
            to = paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/prec"))
  
  cat("", "\n", "Removing temporary files...", "\n")
  file.remove(list.files(saga.env$workspace, pattern = gsub(".sgrd", "", nm), full.names = T))
  file.remove(list.files(saga.env$workspace, pattern = "spline", full.names = T))
}
