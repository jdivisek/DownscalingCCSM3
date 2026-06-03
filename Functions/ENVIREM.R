###DEFINE FUNCTIONS FOR CALCULATION OF ENVIREM VARIABLES--------------------------------------------------------------------------

###maximum temperature of coldest month--------------------------------------------------------
maxTempColdest.SAGA <- function(tmean.paths, tmax.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  cat("", "Calculating coldest month...", "\n")
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(tmean.paths, collapse = "; "), 
                                                MIN="coldestMonth.sgrd"), env=saga.env, show.output.on.console=F)
  
  coldestMonth <- paste(saga.env$workspace, "/coldestMonth.sgrd", sep="")
  
  cat("", "Calculating maximum temperature of coldest month...", "\n")
  for(i in 1:12)
  {
    print(i)
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(coldestMonth, tmean.paths[i], tmax.paths[i]), collapse = "; "), 
                                                RESULT=paste0("maxTempColdest__", sprintf("%02d", i), ".sgrd"),
                                                FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
  }
  
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("maxTempColdest__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                MAX=paste0("maxTempColdest", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "maxTempColdest__", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "coldestMonth", full.names = T))
}

###minimum temperature of warmest month--------------------------------------------------------
minTempWarmest.SAGA <- function(tmean.paths, tmin.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  cat("", "Calculating warmest month...", "\n")
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(tmean.paths, collapse = "; "), 
                                                MAX="warmestMonth.sgrd"), env=saga.env, show.output.on.console=F)
  
  warmestMonth <- paste(saga.env$workspace, "/warmestMonth.sgrd", sep="")
  
  cat("", "Calculating minumum temperature of warmest month...", "\n")
  for(i in 1:12)
  {
    print(i)
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(warmestMonth, tmean.paths[i], tmin.paths[i]), collapse = "; "), 
                                                RESULT=paste0("minTempWarmest__", sprintf("%02d", i), ".sgrd"),
                                                FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
  }
  
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("minTempWarmest__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                MIN=paste0("minTempWarmest", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "minTempWarmest__", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "warmestMonth", full.names = T))
}

##monthlyPET----------------------------------------------------------------------------------
monthlyPET.SAGA <- function(tmean.paths, tmin.paths, tmax.paths, solrad.paths, saga.env)
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  for(i in 1:12)
  {
    cat("", paste("Calculating", month.name[i], "PET...", sep=" "), "\n")
    
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(solrad.paths[i], tmean.paths[i], tmax.paths[i], tmin.paths[i]), collapse = "; "), 
                                                RESULT="tmpPET.sgrd",
                                                FORMULA="0.0023 * (g1 * 30) * (g2 + 17.8) * abs(g3 - g4) ^ 0.5"), env=saga.env, show.output.on.console=F)
    
    rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="tmpPET.sgrd", 
                                                RESULT=paste0("pet_", sprintf("%02d", i), ".sgrd"),
                                                FORMULA="ifelse(g1 < 0, 0, g1)"), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(path = saga.env$workspace, pattern = "tmpPET", full.names = T))
  }
}

###annualPET-----------------------------------------------------------------------------------
annualPET.SAGA <- function(pet.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  rsaga.geoprocessor("grid_calculus", 8, list(GRIDS=paste(pet.paths, collapse = "; "), 
                                              RESULT=paste0("annualPET", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
}

###PETTempQuarter---------------------------------------------------------------------------
PETTempQuarter.SAGA <- function(pet.paths, tmean.paths, saga.env, vars=c("PETColdestQuarter", "PETWarmestQuarter"), suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  ##Calculate mean temperature and PET for all possible quarters
  possibleQuarters <- c(1:12, 1, 2)
  
  cat("", paste("Calculating mean temperature and PET for all possible quarters (12 x 3 consecutive months)...", sep=" "), "\n")
  for(i in 1:12)
  {
    print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(tmean.paths[possibleQuarters[i:(i + 2)]], collapse = "; "), 
                                                  MEAN=paste0("tempQuarter_", sprintf("%02d", i), ".sgrd")), env=saga.env, show.output.on.console=F)
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(pet.paths[possibleQuarters[i:(i + 2)]], collapse = "; "), 
                                                  MEAN=paste0("petQuarter_", sprintf("%02d", i), ".sgrd")), env=saga.env, show.output.on.console=F)
    
  }
  
  ###Calculate PETColdestQuarter*********************************************
  if("PETColdestQuarter" %in% vars)
  {
    cat("", paste("Calculating PET of coldest quarter...", sep=" "), "\n")
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("tempQuarter_", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "),
                                                  MIN="minTempQuarter.sgrd"), env=saga.env, show.output.on.console=F)
    
    for(i in 1:12)
    {
      print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
      
      tempQuarter <- paste0("tempQuarter_", sprintf("%02d", i), ".sgrd")
      petQuarter <- paste0("petQuarter_", sprintf("%02d", i), ".sgrd")
      
      rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c("minTempQuarter.sgrd", tempQuarter, petQuarter), collapse = "; "), 
                                                  RESULT=paste0("PETColdestQuarter__", sprintf("%02d", i), ".sgrd"),
                                                  FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
    }
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("PETColdestQuarter__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MEAN=paste0("PETColdestQuarter", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(path = saga.env$workspace, pattern = "PETColdestQuarter__", full.names = T))
    file.remove(list.files(path = saga.env$workspace, pattern = "minTempQuarter", full.names = T))
  }
  
  ###Calculate PETWarmestQuarter*********************************************
  if("PETWarmestQuarter" %in% vars)
  {
    cat("", paste("Calculating PET of warmest quarter...", sep=" "), "\n")
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("tempQuarter_", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MAX="maxTempQuarter.sgrd"), env=saga.env, show.output.on.console=F)
    
    for(i in 1:12)
    {
      print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
      
      tempQuarter <- paste0("tempQuarter_", sprintf("%02d", i), ".sgrd")
      petQuarter <- paste0("petQuarter_", sprintf("%02d", i), ".sgrd")
      
      rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c("maxTempQuarter.sgrd", tempQuarter, petQuarter), collapse = "; "), 
                                                  RESULT=paste0("PETWarmestQuarter__", sprintf("%02d", i), ".sgrd"),
                                                  FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
    }
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("PETWarmestQuarter__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MEAN=paste0("PETWarmestQuarter", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(path = saga.env$workspace, pattern = "PETWarmestQuarter__", full.names = T))
    file.remove(list.files(path = saga.env$workspace, pattern = "maxTempQuarter", full.names = T))
  }
  
  file.remove(list.files(path = saga.env$workspace, pattern = "tempQuarter_", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "petQuarter_", full.names = T))
  
}

###PETMoistQuarter-----------------------------------------------------------------------------------------------------------------------------------------
PETMoistQuarter.SAGA <- function(pet.paths, prec.paths, saga.env, vars=c("PETDriestQuarter", "PETWettestQuarter"), suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  ##Calculate mean precipitation and PET for all possible quarters
  possibleQuarters <- c(1:12, 1, 2)
  
  cat("", paste("Calculating mean precipitation and PET for all possible quarters (12 x 3 consecutive months)...", sep=" "), "\n")
  for(i in 1:12)
  {
    print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(prec.paths[possibleQuarters[i:(i + 2)]], collapse = "; "), 
                                                  MEAN=paste0("precQuarter_", sprintf("%02d", i), ".sgrd")), env=saga.env, show.output.on.console=F)
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(pet.paths[possibleQuarters[i:(i + 2)]], collapse = "; "), 
                                                  MEAN=paste0("petQuarter_", sprintf("%02d", i), ".sgrd")), env=saga.env, show.output.on.console=F)
    
  }
  
  ###Calculate PETDriestQuarter*********************************************
  if("PETDriestQuarter" %in% vars)
  {
    cat("", paste("Calculating PET of driest quarter...", sep=" "), "\n")
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("precQuarter_", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "),
                                                  MIN="minPrecQuarter.sgrd"), env=saga.env, show.output.on.console=F)
    
    for(i in 1:12)
    {
      print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
      
      precQuarter <- paste0("precQuarter_", sprintf("%02d", i), ".sgrd")
      petQuarter <- paste0("petQuarter_", sprintf("%02d", i), ".sgrd")
      
      rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c("minPrecQuarter.sgrd", precQuarter, petQuarter), collapse = "; "), 
                                                  RESULT=paste0("PETDriestQuarter__", sprintf("%02d", i), ".sgrd"),
                                                  FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
    }
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("PETDriestQuarter__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MEAN=paste0("PETDriestQuarter", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(path = saga.env$workspace, pattern = "PETDriestQuarter__", full.names = T))
    file.remove(list.files(path = saga.env$workspace, pattern = "minPrecQuarter", full.names = T))
  }
  
  ###Calculate PETWettestQuarter*********************************************
  if("PETWettestQuarter" %in% vars)
  {
    cat("", paste("Calculating PET of wettest quarter...", sep=" "), "\n")
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("precQuarter_", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MAX="maxPrecQuarter.sgrd"), env=saga.env, show.output.on.console=F)
    
    for(i in 1:12)
    {
      print(paste(month.name[possibleQuarters[i]], "-", month.name[possibleQuarters[i+2]]))
      
      precQuarter <- paste0("precQuarter_", sprintf("%02d", i), ".sgrd")
      petQuarter <- paste0("petQuarter_", sprintf("%02d", i), ".sgrd")
      
      rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c("maxPrecQuarter.sgrd", precQuarter, petQuarter), collapse = "; "), 
                                                  RESULT=paste0("PETWettestQuarter__", sprintf("%02d", i), ".sgrd"),
                                                  FORMULA="ifelse(g1 = g2, g3, nodata())"), env=saga.env, show.output.on.console=F)
    }
    
    rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(paste0("PETWettestQuarter__", sprintf("%02d", 1:12), ".sgrd"), collapse = "; "), 
                                                  MEAN=paste0("PETWettestQuarter", suffix, ".sgrd")), env=saga.env, show.output.on.console=F)
    
    file.remove(list.files(path = saga.env$workspace, pattern = "PETWettestQuarter__", full.names = T))
    file.remove(list.files(path = saga.env$workspace, pattern = "maxPrecQuarter", full.names = T))
  }
  
  file.remove(list.files(path = saga.env$workspace, pattern = "precQuarter_", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "petQuarter_", full.names = T))
  
}

###PETseasonality--------------------------------------------------------------------------------------------
PETseasonality.SAGA <- function(pet.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(pet.paths, collapse = "; "), 
                                                STDDEV="StdDev.sgrd"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="StdDev.sgrd", RESULT=paste0("PETseasonality", suffix, ".sgrd"),
                                              FORMULA="100 * g1"), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "StdDev", full.names = T))
}

###climaticMoistureIndex-------------------------------------------------------------------------------------
climaticMoistureIndex.SAGA <- function(bio12.path, annualPET, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  # rsaga.geoprocessor("grid_calculus", 8, list(GRIDS=paste(prec.paths, collapse = "; "), RESULT="annualPrec.sgrd"),
  #                    env=saga.env, show.output.on.console=F)
  
  #climatic moisture index
  ## cmi = (P / PET) - 1 when P < PET
  ## cmi = 1 - (PET / P) when P >= PET
  ### where P = annual precipitation, PET = potential evapotranspiration
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(bio12.path, annualPET), collapse = "; "),
                                              RESULT=paste0("climaticMoistureIndex", suffix, ".sgrd"),
                                              FORMULA="ifelse(g1 < g2, (g1 / g2) - 1, 1 - (g2 / g1))"), env=saga.env, show.output.on.console=F)
  
  # file.remove(list.files(path = saga.env$workspace, pattern = "annualPrec", full.names = T))
  
}

###growingDegDays------------------------------------------------------------------------------------------
growingDegDays.SAGA <- function(tmean.paths, baseTemp, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  ##growing degree days = sum of all monthly temps greater than baseTemp, 
  ##multiplied by total number of days
  
  Ndays <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  
  f <- paste(paste0("ifelse((g", 1:12, " - ", baseTemp, ") < 0, 0, (g", 1:12, " - ", baseTemp, ") * ", Ndays, ")"), collapse = " + ") 
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(tmean.paths, collapse = "; "),
                                              RESULT=paste0("growingDegDays", baseTemp, suffix, ".sgrd"),
                                              FORMULA=f), env=saga.env, show.output.on.console=F)
}

###monthCountByTemp----------------------------------------------------------------------------------------

monthCountByTemp.SAGA <- function(tmean.paths, minTemp, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  ##Number of months with mean temperature greater than some base temp
  
  f <- paste(paste0("ifelse(g", 1:12, " > ", minTemp, ", 1, 0)"), collapse = " + ")
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(tmean.paths, collapse = "; "),
                                              RESULT=paste0("monthCountByTemp", minTemp, suffix, ".sgrd"),
                                              FORMULA=f), env=saga.env, show.output.on.console=F)
}

###continentality------------------------------------------------------------------------------------------
continentality.SAGA <- function(tmean.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(tmean.paths, collapse = "; "), 
                                                MAX="meantempWarmest.sgrd"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("statistics_grid", 4, list(GRIDS=paste(tmean.paths, collapse = "; "), 
                                                MIN="meantempColdest.sgrd"), env=saga.env, show.output.on.console=F)
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="meantempWarmest.sgrd; meantempColdest.sgrd",
                                              RESULT=paste0("continentality", suffix, ".sgrd"),
                                              FORMULA="g1 - g2"), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "meantempWarmest", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "meantempColdest", full.names = T))
}

###aridityIndexThornthwaite---------------------------------------------------------------------------------

aridityIndexThornthwaite.SAGA <- function(prec.paths, pet.paths, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  # \code{Thornthwaite aridity index = 100d / n}
  # where d = sum of monthly differences between precipitation and PET for months where precip < PET
  # where n = sum of monthly PET for those months
  
  d <- paste(paste0("ifelse(g", 1:12, " < g", 13:24, ", g", 13:24, " - g", 1:12, ", 0)"), collapse = " + ")
  n <- paste(paste0("ifelse(g", 1:12, " < g", 13:24, ", g", 13:24, ", 0)"), collapse = " + ")
  
  cat("", paste("Calculating d component of Thornthwaite's equation...", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(prec.paths, pet.paths), collapse = "; "),
                                              RESULT="d_component.sgrd",
                                              FORMULA=d), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Calculating n component of Thornthwaite's equation...", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(prec.paths, pet.paths), collapse = "; "),
                                              RESULT="n_component.sgrd",
                                              FORMULA=n), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Calculating aridity index...", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS="d_component.sgrd; n_component.sgrd",
                                              RESULT=paste0("aridityIndexThornthwaite", suffix, ".sgrd"),
                                              FORMULA="ifelse(g1 = 0, 0, 100 * g1 / g2)"), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "_component", full.names = T))
  
}

###embergerQ------------------------------------------------------------------------------------------------
embergerQ.SAGA <- function(bio12.path, bio5.path, bio6.path, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  ## Emberger's pluviometric quotient
  # Q = 2000 P / (M + m + 546.4) (M - m)
  # P = mean annual precip
  # M = mean max temp of warmest month
  # m = mean min temp of coldest month
  
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(bio12.path, bio5.path, bio6.path), collapse = "; "),
                                              RESULT=paste0("embergerQ", suffix, ".sgrd"),
                                              FORMULA="2000 * g1 / ((g2 + g3 + 546.4) * (g2 - g3))"), env=saga.env, show.output.on.console=F)
}

####thermicityIndex-----------------------------------------------------------------------------------------
thermicityIndex.SAGA <- function(bio1.path, bio6.path, maxTempColdest, ci, saga.env, suffix="")
{
  require(RSAGA)
  if(saga.env$workspace == ".") {saga.env$workspace <- getwd()}
  
  cat("", paste("Calculating Thermicity index...", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(bio1.path, bio6.path, maxTempColdest), collapse = "; "),
                                              RESULT="uncompensatedTI.sgrd",
                                              FORMULA="(g1 + g2 + g3) * 10"), env=saga.env, show.output.on.console=F)
  
  ##ci reclassification
  #compensation 1 = ifelse(ci < 9, thermicity - ((9 - ci) * 10), thermicity)
  #compensation 2 = ifelse(ci > 18 & ci <= 21), thermicity + ((ci - 18) * 5), thermicity)
  #compensation 3 = ifelse(ci > 21 & ci <= 28), thermicity + (((ci - 21) * 15) + 15), thermicity)
  #compensation 4 = ifelse(ci > 28 & ci <= 46), thermicity + (((ci - 28) * 25) + 15 + 105), thermicity)
  #compensation 5 = ifelse(ci > 46 & ci <= 65), thermicity + (((ci - 46) * 30) + 15 + 105 + 425), thermicity)
  
  tab <- matrix(c(18, 21, 2, 21, 28, 3, 28, 46, 4, 46, 65, 5), nrow=4, ncol=3, byrow = T, dimnames = list(c(1:4), c("minimum", "maximum", "new")))
  write.table(tab, file=paste0(saga.env$workspace, "/reclassification.txt"), sep="\t", dec=".", quote=F, row.names = F, col.names = T)
  
  rsaga.geoprocessor("grid_tools", 15, list(INPUT=ci, RETAB_2="reclassification.txt", 
                                            RESULT="ci_reclassified.sgrd", METHOD=3,
                                            TOPERATOR=2, F_MIN="minimum", F_MAX="maximum",
                                            F_CODE="new", OTHEROPT="1", OTHERS=0), env=saga.env, show.output.on.console=F)
  
  
  cat("", paste("Compensation... 1", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(ci, "uncompensatedTI.sgrd"), collapse = "; "),
                                              RESULT="compensation_1.sgrd",
                                              FORMULA="ifelse(g1 < 9, g2 - ((9 - g1) * 10), g2)"), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Compensation... 2", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(ci, "compensation_1.sgrd", "ci_reclassified.sgrd"), collapse = "; "),
                                              RESULT="compensation_2.sgrd",
                                              FORMULA="ifelse(g3 = 2, g2 + ((g1 - 18) * 5), g2)"), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Compensation... 3", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(ci, "compensation_2.sgrd", "ci_reclassified.sgrd"), collapse = "; "),
                                              RESULT="compensation_3.sgrd",
                                              FORMULA="ifelse(g3 = 3, g2 + (((g1 - 21) * 15) + 15), g2)"), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Compensation... 4", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(ci, "compensation_3.sgrd", "ci_reclassified.sgrd"), collapse = "; "),
                                              RESULT="compensation_4.sgrd",
                                              FORMULA="ifelse(g3 = 4, g2 + (((g1 - 28) * 25) + 15 + 105), g2)"), env=saga.env, show.output.on.console=F)
  
  cat("", paste("Compensation... 5", sep=" "), "\n")
  rsaga.geoprocessor("grid_calculus", 1, list(GRIDS=paste(c(ci, "compensation_4.sgrd", "ci_reclassified.sgrd"), collapse = "; "),
                                              RESULT=paste0("thermicityIndex", suffix, ".sgrd"),
                                              FORMULA="ifelse(g3 = 5, g2 + (((g1 - 46) * 30) + 15 + 105 + 425), g2)"), env=saga.env, show.output.on.console=F)
  
  file.remove(list.files(path = saga.env$workspace, pattern = "uncompensatedTI", full.names = T))
  file.remove(paste0(saga.env$workspace, "/reclassification.txt"))
  file.remove(list.files(path = saga.env$workspace, pattern = "ci_reclassified", full.names = T))
  file.remove(list.files(path = saga.env$workspace, pattern = "compensation_", full.names = T))
}