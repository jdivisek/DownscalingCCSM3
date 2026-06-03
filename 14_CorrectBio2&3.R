###CORRECT NEGATIVE VALUES IN BIO2 AND BIO3---------------------------------------------------------------
##and compress corrected layers
library(raster)
library(stringr)
library(RSAGA)

###Correct bio2-------------------------------------------------------------------------------------------
tw <- seq(50, 20950, 100)

bio.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim/", tw, "BP/bio2_", tw, "BP.sgrd")
mask.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/land_masks/mask.land_", tw, "BP.sgrd")

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env$workspace <- paste0(getwd(), "/temp")
saga.env

# rsaga.get.libraries(path = saga.env$modules)
# rsaga.get.modules("grid_calculus", env = saga.env)
# rsaga.get.usage("grid_calculus",1, env = saga.env)
# rsaga.get.modules("io_gdal", env = saga.env)
# rsaga.get.usage("io_gdal",2, env = saga.env)

for(i in seq(1, length(tw)))
{
  print(tw[i])
  
  filename <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim/bio2_corrected/bio2_", tw[i], "BP.sgrd")
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=bio.paths[i], 
                                              RESULT=filename,
                                              FORMULA="ifelse(g1 < 0, 0, g1)"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste0(c(filename, mask.paths[i]), collapse = "; "), 
                                              RESULT=paste0("bio2_", tw[i], "BP.sgrd"),
                                              FORMULA="(g1 * g2) * 10", TYPE="6"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=paste0("bio2_", tw[i], "BP.sgrd"), 
                                        FILE=paste0("bio2_", tw[i], "BP.tif"), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  file.rename(from=paste0("./temp/bio2_", tw[i], "BP.tif"),
              to=paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/bio2_corrected/bio2_", tw[i], "BP.tif"))
  file.remove(list.files("./temp", pattern="bio2", full.names = T))
}

###Correct bio3--------------------------------------------------------------------------------
tw <- seq(50, 20950, 100)

bio.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim/", tw, "BP/bio3_", tw, "BP.sgrd")
mask.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/land_masks/mask.land_", tw, "BP.sgrd")

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env$workspace <- paste0(getwd(), "/temp")
saga.env

# rsaga.get.libraries(path = saga.env$modules)
# rsaga.get.modules("grid_calculus", env = saga.env)
# rsaga.get.usage("grid_calculus",1, env = saga.env)
# rsaga.get.modules("io_gdal", env = saga.env)
# rsaga.get.usage("io_gdal",2, env = saga.env)

for(i in seq(1, length(tw)))
{
  print(tw[i])
  
  filename <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim/bio3_corrected/bio3_", tw[i], "BP.sgrd")
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=bio.paths[i], 
                                              RESULT=filename,
                                              FORMULA="ifelse(g1 < 0, 0, g1)"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste0(c(filename, mask.paths[i]), collapse = "; "), 
                                              RESULT=paste0("bio3_", tw[i], "BP.sgrd"),
                                              FORMULA="(g1 * g2) * 10", TYPE="6"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("io_gdal", 2, list(GRIDS=paste0("bio3_", tw[i], "BP.sgrd"), 
                                        FILE=paste0("bio3_", tw[i], "BP.tif"), 
                                        OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
  
  file.rename(from=paste0("./temp/bio3_", tw[i], "BP.tif"),
              to=paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/bio3_corrected/bio3_", tw[i], "BP.tif"))
  file.remove(list.files("./temp", pattern="bio3", full.names = T))
}



