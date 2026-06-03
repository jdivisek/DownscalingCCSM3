###CALCULATE BIOCLIM AND ENVRIEM VARIABLES---------------------------------------------------------------------------------------------------------
library(raster)
library(RSAGA)
library(stringr)
library(envirem)

###paths to donwcaled layers
##mean temperature
tmean.paths <- list()
tmean.paths[[1]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/01_Jan"), pattern='tif', full.names=TRUE)
tmean.paths[[2]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/02_Feb"), pattern='tif', full.names=TRUE)
tmean.paths[[3]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/03_Mar"), pattern='tif', full.names=TRUE)
tmean.paths[[4]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/04_Apr"), pattern='tif', full.names=TRUE)
tmean.paths[[5]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/05_May"), pattern='tif', full.names=TRUE)
tmean.paths[[6]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/06_Jun"), pattern='tif', full.names=TRUE)
tmean.paths[[7]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/07_Jul"), pattern='tif', full.names=TRUE)
tmean.paths[[8]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/08_Aug"), pattern='tif', full.names=TRUE)
tmean.paths[[9]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/09_Sep"), pattern='tif', full.names=TRUE)
tmean.paths[[10]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/10_Oct"), pattern='tif', full.names=TRUE)
tmean.paths[[11]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/11_Nov"), pattern='tif', full.names=TRUE)
tmean.paths[[12]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmean/12_Dec"), pattern='tif', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  tw <- as.numeric(unlist(lapply(regmatches(tmean.paths[[i]], gregexpr("[[:digit:]]+", tmean.paths[[i]])), FUN=function(x){x[length(x)]})))
  tmean.paths[[i]] <- tmean.paths[[i]][order(tw)]
  # tmean.paths[[i]] <- split(tmean.paths[[i]], ceiling(seq_along(c(tmean.paths[[i]]))/10))
}

##max temperature--------------------------------------------------------------------------
tmax.paths <- list()
tmax.paths[[1]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/01_Jan"), pattern='tif', full.names=TRUE)
tmax.paths[[2]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/02_Feb"), pattern='tif', full.names=TRUE)
tmax.paths[[3]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/03_Mar"), pattern='tif', full.names=TRUE)
tmax.paths[[4]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/04_Apr"), pattern='tif', full.names=TRUE)
tmax.paths[[5]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/05_May"), pattern='tif', full.names=TRUE)
tmax.paths[[6]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/06_Jun"), pattern='tif', full.names=TRUE)
tmax.paths[[7]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/07_Jul"), pattern='tif', full.names=TRUE)
tmax.paths[[8]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/08_Aug"), pattern='tif', full.names=TRUE)
tmax.paths[[9]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/09_Sep"), pattern='tif', full.names=TRUE)
tmax.paths[[10]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/10_Oct"), pattern='tif', full.names=TRUE)
tmax.paths[[11]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/11_Nov"), pattern='tif', full.names=TRUE)
tmax.paths[[12]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmax/12_Dec"), pattern='tif', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  tw <- as.numeric(unlist(lapply(regmatches(tmax.paths[[i]], gregexpr("[[:digit:]]+", tmax.paths[[i]])), FUN=function(x){x[length(x)]})))
  tmax.paths[[i]] <- tmax.paths[[i]][order(tw)]
  # tmax.paths[[i]] <- split(tmax.paths[[i]], ceiling(seq_along(c(tmax.paths[[i]]))/10))
}

##min temperature-------------------------------------------------------------------------
tmin.paths <- list()
tmin.paths[[1]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/01_Jan"), pattern='tif', full.names=TRUE)
tmin.paths[[2]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/02_Feb"), pattern='tif', full.names=TRUE)
tmin.paths[[3]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/03_Mar"), pattern='tif', full.names=TRUE)
tmin.paths[[4]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/04_Apr"), pattern='tif', full.names=TRUE)
tmin.paths[[5]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/05_May"), pattern='tif', full.names=TRUE)
tmin.paths[[6]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/06_Jun"), pattern='tif', full.names=TRUE)
tmin.paths[[7]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/07_Jul"), pattern='tif', full.names=TRUE)
tmin.paths[[8]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/08_Aug"), pattern='tif', full.names=TRUE)
tmin.paths[[9]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/09_Sep"), pattern='tif', full.names=TRUE)
tmin.paths[[10]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/10_Oct"), pattern='tif', full.names=TRUE)
tmin.paths[[11]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/11_Nov"), pattern='tif', full.names=TRUE)
tmin.paths[[12]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/tmin/12_Dec"), pattern='tif', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  tw <- as.numeric(unlist(lapply(regmatches(tmin.paths[[i]], gregexpr("[[:digit:]]+", tmin.paths[[i]])), FUN=function(x){x[length(x)]})))
  tmin.paths[[i]] <- tmin.paths[[i]][order(tw)]
  # tmin.paths[[i]] <- split(tmin.paths[[i]], ceiling(seq_along(c(tmin.paths[[i]]))/10))
}

##precipitation----------------------------------------------------------------------------
prec.paths <- list()
prec.paths[[1]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/01_Jan"), pattern='tif', full.names=TRUE)
prec.paths[[2]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/02_Feb"), pattern='tif', full.names=TRUE)
prec.paths[[3]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/03_Mar"), pattern='tif', full.names=TRUE)
prec.paths[[4]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/04_Apr"), pattern='tif', full.names=TRUE)
prec.paths[[5]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/05_May"), pattern='tif', full.names=TRUE)
prec.paths[[6]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/06_Jun"), pattern='tif', full.names=TRUE)
prec.paths[[7]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/07_Jul"), pattern='tif', full.names=TRUE)
prec.paths[[8]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/08_Aug"), pattern='tif', full.names=TRUE)
prec.paths[[9]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/09_Sep"), pattern='tif', full.names=TRUE)
prec.paths[[10]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/10_Oct"), pattern='tif', full.names=TRUE)
prec.paths[[11]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/11_Nov"), pattern='tif', full.names=TRUE)
prec.paths[[12]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/prec/12_Dec"), pattern='tif', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  tw <- as.numeric(unlist(lapply(regmatches(prec.paths[[i]], gregexpr("[[:digit:]]+", prec.paths[[i]])), FUN=function(x){x[length(x)]})))
  prec.paths[[i]] <- prec.paths[[i]][order(tw)]
  # prec.paths[[i]] <- split(prec.paths[[i]], ceiling(seq_along(c(prec.paths[[i]]))/10))
}

##solar radiation------------------------------------------------------------------------------------

solrad.paths <- list()
solrad.paths[[1]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/01_Jan"), pattern='tif', full.names=TRUE)
solrad.paths[[2]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/02_Feb"), pattern='tif', full.names=TRUE)
solrad.paths[[3]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/03_Mar"), pattern='tif', full.names=TRUE)
solrad.paths[[4]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/04_Apr"), pattern='tif', full.names=TRUE)
solrad.paths[[5]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/05_May"), pattern='tif', full.names=TRUE)
solrad.paths[[6]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/06_Jun"), pattern='tif', full.names=TRUE)
solrad.paths[[7]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/07_Jul"), pattern='tif', full.names=TRUE)
solrad.paths[[8]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/08_Aug"), pattern='tif', full.names=TRUE)
solrad.paths[[9]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/09_Sep"), pattern='tif', full.names=TRUE)
solrad.paths[[10]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/10_Oct"), pattern='tif', full.names=TRUE)
solrad.paths[[11]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/11_Nov"), pattern='tif', full.names=TRUE)
solrad.paths[[12]] <- list.files(path= paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/solrad/12_Dec"), pattern='tif', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  tw <- as.numeric(unlist(lapply(regmatches(solrad.paths[[i]], gregexpr("[[:digit:]]+", solrad.paths[[i]])), FUN=function(x){x[length(x)]})))
  solrad.paths[[i]] <- solrad.paths[[i]][order(tw)]
  # solrad.paths[[i]] <- split(solrad.paths[[i]], ceiling(seq_along(c(solrad.paths[[i]]))/10))
}

#paths to folders for biclimatic variables
tw <- seq(50, 20950, 100) #define time windows
bio.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/bioclim/", tw, "BP")

# for(i in seq(1, length(tw)))
# {
#   dir.create(path = bio.paths[i])
# }

#paths to folders for envirem variables
envi.paths <- paste0(getwd(), "/GIS_database/Paleoclimates_CCSM3/SAGA/envirem/", tw, "BP")

# for(i in seq(1, length(tw)))
# {
#   dir.create(path = envi.paths[i])
# }


###CALCULATE BIOCLIM AND ENVIREM VARIABLES----------------------------------------------------------
#require SAGA GIS 6.3.0 to calculate bio12 as sum of monthly precipitation amounts 
#SAGA 2.3.1 calculates bio12 as an arithmetic mean

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
# rsaga.get.modules("climate_tools", env = saga.env)
# rsaga.get.usage("climate_tools",10, env = saga.env)

source("./Functions/ENVIREM.R")

n <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")

for(i in seq(1,210))#loop for 100 yrs time windows
{
  #saga.env$workspace <- bio.paths[i]

  cat("", "\n", paste("Calculating bioclimatic variables for", tw[i], "BP"), "\n")

  bio.nms <- paste0("bio", 1:19, "_", seq(50, 20950, 100)[i], "BP.sgrd")

  #bioclim variables
  rsaga.geoprocessor("climate_tools", 10, list(TMEAN=paste0(unlist(lapply(tmean.paths, FUN = function(x){x[i]})), collapse = "; "),
                                               TMIN=paste0(unlist(lapply(tmin.paths, FUN = function(x){x[i]})), collapse = "; "),
                                               TMAX=paste0(unlist(lapply(tmax.paths, FUN = function(x){x[i]})), collapse = "; "),
                                               P=paste0(unlist(lapply(prec.paths, FUN = function(x){x[i]})), collapse = "; "),
                                               BIO_01=bio.nms[1], BIO_02=bio.nms[2], BIO_03=bio.nms[3],
                                               BIO_04=bio.nms[4], BIO_05=bio.nms[5], BIO_06=bio.nms[6],
                                               BIO_07=bio.nms[7], BIO_08=bio.nms[8], BIO_09=bio.nms[9],
                                               BIO_10=bio.nms[10], BIO_11=bio.nms[11], BIO_12=bio.nms[12],
                                               BIO_13=bio.nms[13], BIO_14=bio.nms[14], BIO_15=bio.nms[15],
                                               BIO_16=bio.nms[16], BIO_17=bio.nms[17], BIO_18=bio.nms[18],
                                               BIO_19=bio.nms[19], SEASONALITY="1"), env = saga.env, show.output.on.console = F)

  file.rename(from=paste0(saga.env$workspace, "/", list.files(saga.env$workspace, full.names = F)),
              to=paste0(bio.paths[i], "/", list.files(saga.env$workspace, full.names = F)))
  
  
  #envirem variables
  #saga.env$workspace <- envi.paths[i]
  
  if(!file.exists(paste0(envi.paths[i], "/annualPET_", tw[i], "BP.sgrd")))
  {
    cat("", "\n", paste0("Calculating envirem variables for ", tw[i], " BP"), "\n")
    
    ##create paths to bioclimatic variables
    bio1.path <- paste0(bio.paths[i], "/bio1_", tw[i], "BP.sgrd")
    bio5.path <- paste0(bio.paths[i], "/bio5_", tw[i], "BP.sgrd")
    bio6.path <- paste0(bio.paths[i], "/bio6_", tw[i], "BP.sgrd")
    bio12.path <- paste0(bio.paths[i], "/bio12_", tw[i], "BP.sgrd")
    
    ###temp extremes
    cat("", "\n", "Maximum temperature of the coldest month", "\n")
    maxTempColdest.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), tmax.paths=unlist(lapply(tmax.paths, FUN = function(x){x[i]})), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    cat("", "\n", "Minimum temperature of the warmest month", "\n")
    minTempWarmest.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), tmin.paths=unlist(lapply(tmin.paths, FUN = function(x){x[i]})), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###growing degree days
    cat("", "\n", "Growing degree days above 0°C", "\n")
    growingDegDays.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), baseTemp=0, saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    cat("", "\n", "Growing degree days above 5°C", "\n")
    growingDegDays.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), baseTemp=5, saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###month count by deg
    cat("", "\n", "Number of months with mean temperature greater than 10°C", "\n")
    monthCountByTemp.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), minTemp=10, saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###continentality index
    cat("", "\n", "Continentality index", "\n")
    continentality.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###thermicity index
    cat("", "\n", "Thermicity index", "\n")
    thermicityIndex.SAGA(bio1.path=bio1.path, bio6.path=bio6.path, maxTempColdest=paste0("maxTempColdest_", tw[i], "BP.sgrd"), ci=paste0("continentality_", tw[i], "BP.sgrd"), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ##emberger's Q
    cat("", "\n", "Emberger's Q", "\n")
    embergerQ.SAGA(bio12.path=bio12.path, bio5.path=bio5.path, bio6.path=bio6.path, saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###PET extremes
    cat("", "\n", "Monthly PET", "\n")
    monthlyPET.SAGA(tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})),
                    tmin.paths=unlist(lapply(tmin.paths, FUN = function(x){x[i]})),
                    tmax.paths=unlist(lapply(tmax.paths, FUN = function(x){x[i]})),
                    solrad.paths=unlist(lapply(solrad.paths, FUN = function(x){x[i]})), saga.env=saga.env)
    
    cat("", "\n", "PET extremes", "\n")
    PETTempQuarter.SAGA(pet.paths=paste0("pet_", sprintf("%02d", 1:12), ".sgrd"),
                        tmean.paths=unlist(lapply(tmean.paths, FUN = function(x){x[i]})),
                        saga.env=saga.env, vars=c("PETColdestQuarter", "PETWarmestQuarter"), suffix=paste0("_", tw[i], "BP"))
    PETMoistQuarter.SAGA(pet.paths=paste0("pet_", sprintf("%02d", 1:12), ".sgrd"),
                         prec.paths=unlist(lapply(prec.paths, FUN = function(x){x[i]})),
                         saga.env=saga.env, vars=c("PETDriestQuarter", "PETWettestQuarter"), suffix=paste0("_", tw[i], "BP"))
    
    ###annual PET
    cat("", "\n", "Annual PET", "\n")
    annualPET.SAGA(pet.paths=paste0("pet_", sprintf("%02d", 1:12), ".sgrd"), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###PET seasonality
    cat("", "\n", "PET seasonality", "\n")
    PETseasonality.SAGA(pet.paths=paste0("pet_", sprintf("%02d", 1:12), ".sgrd"), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###climatic moisture index
    cat("", "\n", "Climatic moisture index", "\n")
    climaticMoistureIndex.SAGA(bio12.path=bio12.path, annualPET=paste0("annualPET_", tw[i], "BP.sgrd"), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    ###Thornthwaite aridity index
    cat("", "\n", "Thornthwaite aridity index", "\n")
    aridityIndexThornthwaite.SAGA(prec.paths=unlist(lapply(prec.paths, FUN = function(x){x[i]})),
                                  pet.paths=paste0("pet_", sprintf("%02d", 1:12), ".sgrd"), saga.env=saga.env, suffix=paste0("_", tw[i], "BP"))
    
    file.remove(list.files(saga.env$workspace, "pet_", full.names = T))
    
    file.rename(from=paste0(saga.env$workspace, "/", list.files(saga.env$workspace, full.names = F)),
                to=paste0(envi.paths[i], "/", list.files(saga.env$workspace, full.names = F)))
  }
}
Sys.time()
