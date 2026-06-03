###DATA COMPRESSION-------------------------------------------------------------------------------
library(raster)
library(stringr)
library(RSAGA)

###Paths to bioclimatic and envirem variables
tw <- seq(50, 20950, 100)
bio.paths <- list()
bio.names <- paste0("bio", 1:19)

for(i in 1:19)
{
  bio.paths[[i]] <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim_NoExtremes/", tw, "BP/", bio.names[i], "_", tw, "BP.sgrd")
}

envi.paths <- list()

envi.names <- list.files(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/envirem/50BP", pattern="sgrd",full.names = F)
envi.names <- unlist(lapply(str_split(envi.names, "_"), FUN=function(x){x[1]}))

for(i in seq(1, length(envi.names)))
{
  envi.paths[[i]] <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/envirem_NoExtremes/", tw, "BP/", envi.names[i], "_", tw, "BP.sgrd")
}

###create folders for output data
##bioclim
for(i in seq(1, length(bio.names)))
{
  dir.create(path = paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/", bio.names[i]))
}

#envirem
for(i in seq(1, length(envi.names)))
{
  dir.create(path = paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/", envi.names[i]))
}

###COMPRESS BIOCLIM VARIABLES-----------------------------------------------------------------------

saga.env <- rsaga.env()
saga.env$path <- "C:/saga-6.3.0_x64"
saga.env$modules <- "C:/saga-6.3.0_x64/tools"
saga.env$version <- "6.3.0"
saga.env$cores <- 5
saga.env
saga.env$workspace <- paste0(getwd(), "/temp")

# rsaga.get.libraries(path = saga.env$modules)
# rsaga.get.modules("grid_calculus", env = saga.env)
# rsaga.get.usage("grid_calculus",1, env = saga.env)
# rsaga.get.modules("io_gdal", env = saga.env)
# rsaga.get.usage("io_gdal",2, env = saga.env)


mask.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/land_masks/mask.land_", tw, "BP.sgrd")

multiplier <- c(rep(10,11), rep(1,8)) #define scaling factor
names(multiplier) <- bio.names
multiplier

for(q in seq(1, length(bio.names)))
{
  print(bio.names[q])
  
  for(i in seq(1,length(tw)))
  {
    print(tw[i])
    
    filename <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/", bio.names[q], "/", bio.names[q], "_", tw[i], "BP.tif")
    
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste0(c(bio.paths[[q]][i], mask.paths[i]), collapse = "; "), 
                                                RESULT="compressed.sgrd",
                                                FORMULA=paste0("(g1 * g2) * ", multiplier[q]), TYPE="6"), env=saga.env, show.output.on.console=F)
    
    rsaga.geoprocessor("io_gdal", 2, list(GRIDS="compressed.sgrd", FILE=filename, 
                                          OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(saga.env$workspace, pattern = "compressed", full.names = T))
  }
  
}
Sys.time()

###COMPRESS ENVIREM------------------------------------------------------------------------------------------------
mask.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/land_masks/mask.land_", tw, "BP.sgrd")

multiplier <- c(1,10,1000,10,1,1,1,10,10,1,1,1,1,1,1,1) #define scaling factor
names(multiplier) <- envi.names
multiplier

for(q in seq(1, length(envi.names)))
{
  print(envi.names[q])
  
  for(i in seq(1,length(tw)))
  {
    print(tw[i])
    
    filename <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/FOR_SHARING/", envi.names[q], "/", envi.names[q], "_", tw[i], "BP.tif")
    
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste0(c(envi.paths[[q]][i], mask.paths[i]), collapse = "; "), 
                                                RESULT="compressed.sgrd",
                                                FORMULA=paste0("(g1 * g2) * ", multiplier[q]), TYPE="6"), env=saga.env, show.output.on.console=F)
    
    rsaga.geoprocessor("io_gdal", 2, list(GRIDS="compressed.sgrd", FILE=filename, 
                                          OPTIONS="COMPRESS=DEFLATE PREDICTOR=2 ZLEVEL=6"), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(saga.env$workspace, pattern = "compressed", full.names = T))
  }
  
}
Sys.time()
