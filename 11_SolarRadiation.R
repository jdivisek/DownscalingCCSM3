###CREATE SOLAR RADIATION RASTERS FOR ENVIREM VARIABLES------------------------------------------------------------
library(raster)
library(envirem)
library(palinsol)

##load chelsa grids as template
ch.paths <- list.files(path= paste0(getwd(), "/GIS_database/CHELSA 1940-1989/interpolated/tmean"), pattern='sdat', full.names=TRUE)
ch.paths <- ch.paths[str_detect(ch.paths, pattern = ".sdat.", negate = T)]
chelsa <- stack(ch.paths, native=T)
projection(chelsa) <- CRS("+proj=longlat +datum=WGS84")

tw <- seq(50,20950,100) #time windows up to 21,000 BP, each centered on 50 BP, 150 BP, etc.
rasterOptions(tmpdir=paste0(getwd(), "/temp"))

for(i in seq(1, length(tw)))
{
  cat("", "\n", paste0("Calculating solar radiation rasters for ", tw[i], "BP..."), "\n")

  envirem::ETsolradRasters(chelsa[[1]], year=tw[i]*-1, outputDir = paste0(getwd(), "/temp"))

  file.rename(from = list.files(path = paste0(getwd(), "/temp"), pattern = "et_solrad", full.names = TRUE),
              to = c(paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/01_Jan/et_solrad_01_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/02_Feb/et_solrad_02_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/03_Mar/et_solrad_03_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/04_Apr/et_solrad_04_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/05_May/et_solrad_05_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/06_Jun/et_solrad_06_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/07_Jul/et_solrad_07_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/08_Aug/et_solrad_08_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/09_Sep/et_solrad_09_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/10_Oct/et_solrad_10_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/11_Nov/et_solrad_11_", tw[i], "BP.tif"),
                     paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/12_Dec/et_solrad_12_", tw[i], "BP.tif")))
  removeTmpFiles(0)

}