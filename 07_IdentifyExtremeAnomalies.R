##IDENTIFY EXTREME TEMPERATURE ANOMALIES-------------------------------------------------

library(raster)
library(lvmisc)

###MONTHLY MINIMUM TEMPERATURES----------------------------------------------------------
###Load bias files
bias <- stack(list.files(path= paste0(getwd(), "/GIS_database/bias_files/tmin"), pattern='tif', full.names=TRUE))
projection(bias) <- CRS("+proj=longlat +datum=WGS84")
plot(bias, main=month.name)

###Load CCSM3 models
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

#load upscaled chelsa rasters
obs <- stack(list.files(path= paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmin"), pattern='tif', full.names=TRUE))
projection(obs) <- CRS("+proj=longlat +datum=WGS84")
plot(obs, main=month.name)

tmin.out <- list()
tmin.ext <- list()

for(q in 1:12)##loop for 12 months 
{
  print(paste("*******************************", month.name[q], "*******************************", sep= " "))
  
  tmin.out[[q]] <- list()
  tmin.ext[[q]] <- list()
  
  for(i in seq(1,length(m.paths[[q]])))# #loop for each time window over the last 21 000 years #
  {
    print(paste("******",month.name[q], "minimum temperature for", tw[i], "BP ******", sep= " "))
    
    mod <- read.table(m.paths[[q]][i], header = F, sep="", dec = ".")#read PaleoView output
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
    
    tmin.out[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 1.5)]
    tmin.ext[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 3)]
  }
  
  names(tmin.out[[q]]) <- tw
  names(tmin.ext[[q]]) <- tw
}
names(tmin.out) <- month.name
names(tmin.ext) <- month.name

unlist(lapply(tmin.ext[[1]], FUN=function(x){length(x)}))
sum(unlist(lapply(tmin.ext[[4]], FUN=function(x){length(x)})) > 0)

# length(which(unlist(lapply(tmin.ext[[11]], FUN=function(x){length(x)})) > 41))
# 
# dev <- abs(values(d) - median(values(d)))
# d[rank(dev) > 779 & is_outlier(values(d), coef = 3)] <- NA
# 
# plot(d)

###MONTHLY MAXIMUM TEMPERATURES------------------------------------------------------
###Bias files
bias <- stack(list.files(path= paste0(getwd(), "/GIS_database/bias_files/tmax"), pattern='tif', full.names=TRUE))
projection(bias) <- CRS("+proj=longlat +datum=WGS84")
plot(bias, main=month.name)

###Load CCSM3 models
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

tmax.out <- list()
tmax.ext <- list()

for(q in 1:12)##loop for 12 months 
{
  print(paste("*******************************", month.name[q], "*******************************", sep= " "))
  
  tmax.out[[q]] <- list()
  tmax.ext[[q]] <- list()
  
  for(i in seq(1,length(m.paths[[q]])))# #loop for each time window over the last 21 000 years #
  {
    print(paste("******",month.name[q], "maximum temperature for", tw[i], "BP ******", sep= " "))
    
    mod <- read.table(m.paths[[q]][i], header = F, sep="", dec = ".")#read PaleoView output
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
    
    tmax.out[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 1.5)]
    tmax.ext[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 3)]
  }
  
  names(tmax.out[[q]]) <- tw
  names(tmax.ext[[q]]) <- tw
}
names(tmax.out) <- month.name
names(tmax.ext) <- month.name

unlist(lapply(tmax.ext[[1]], FUN=function(x){length(x)}))
sum(unlist(lapply(tmax.ext[[6]], FUN=function(x){length(x)})) > 0)

# dev <- abs(values(d) - median(values(d)))
# d[rank(dev) > 779 & is_outlier(values(d), coef = 3)] <- NA

###MONTHLY MEAN TEMPERATURES------------------------------------------------------
###Load bias files
bias <- stack(list.files(path= paste0(getwd(), "/GIS_database/bias_files/tmean"), pattern='tif', full.names=TRUE))
projection(bias) <- CRS("+proj=longlat +datum=WGS84")
plot(bias, main=month.name)

###Load CCSM3 models
m.paths <- list()
m.paths[[1]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/01_Jan"), pattern='txt', full.names=TRUE)
m.paths[[2]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/02_Feb"), pattern='txt', full.names=TRUE)
m.paths[[3]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/03_Mar"), pattern='txt', full.names=TRUE)
m.paths[[4]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/04_Apr"), pattern='txt', full.names=TRUE)
m.paths[[5]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/05_May"), pattern='txt', full.names=TRUE)
m.paths[[6]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/06_Jun"), pattern='txt', full.names=TRUE)
m.paths[[7]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/07_Jul"), pattern='txt', full.names=TRUE)
m.paths[[8]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/08_Aug"), pattern='txt', full.names=TRUE)
m.paths[[9]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/09_Sep"), pattern='txt', full.names=TRUE)
m.paths[[10]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/10_Oct"), pattern='txt', full.names=TRUE)
m.paths[[11]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/11_Nov"), pattern='txt', full.names=TRUE)
m.paths[[12]] <- list.files(path= paste0(getwd(), "/paleodata_months_Europe/tmean/12_Dec"), pattern='txt', full.names=TRUE)

#sort paths
for(i in 1:12)
{
  m.paths[[i]] <- m.paths[[i]][-c(length(m.paths[[i]]))]
  tw <- as.numeric(unlist(lapply(regmatches(m.paths[[i]], gregexpr("[[:digit:]]+", m.paths[[i]])), FUN=function(x){x[length(x)]})))
  m.paths[[i]] <- m.paths[[i]][order(tw)]
}
tw <- sort(tw)

#load upscaled chelsa rasters
obs <- stack(list.files(path= paste0(getwd(), "/GIS_database/CHELSA_upscaled/tmean"), pattern='tif', full.names=TRUE))
projection(obs) <- CRS("+proj=longlat +datum=WGS84")
plot(obs, main=month.name)

tmean.out <- list()
tmean.ext <- list()

for(q in 1:12)##loop for 12 months 
{
  print(paste("*******************************", month.name[q], "*******************************", sep= " "))
  
  tmean.out[[q]] <- list()
  tmean.ext[[q]] <- list()
  
  for(i in seq(1,length(m.paths[[q]])))# #loop for each time window over the last 21 000 years #
  {
    print(paste("******",month.name[q], "mean temperature for", tw[i], "BP ******", sep= " "))
    
    mod <- read.table(m.paths[[q]][i], header = F, sep="", dec = ".")#read PaleoView output
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
    
    tmean.out[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 1.5)]
    tmean.ext[[q]][[i]] <- values(d)[is_outlier(values(d), coef = 3)]
  }
  
  names(tmean.out[[q]]) <- tw
  names(tmean.ext[[q]]) <- tw
}
names(tmean.out) <- month.name
names(tmean.ext) <- month.name

unlist(lapply(tmean.ext[[9]], FUN=function(x){length(x)}))
sum(unlist(lapply(tmean.ext[[12]], FUN=function(x){length(x)})) > 0)
