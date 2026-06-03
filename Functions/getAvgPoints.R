##This function finds the point within a coarse-resolution grid cell 
##whose value is closest to the value of the given cell

getAvgPoints <- function(r, fact, fact2, res, ext, fun)
{
  require(raster)
  require(geosphere)
  
  cat("", "\n", "Aggregating raster...", "\n")
  ag <- aggregate(r, fact=fact, fun=fun, progress="text")
  
  x.step <- seq(ext@xmin, by=res, length.out=ncol(ag))
  y.step <- seq(ext@ymax, by=res*-1, length.out=nrow(ag))
  
  p <- list()
  
  cat("", "\n", "Looking for cells with the lowest deviation from region mean...", "\n")
  for(q in 1:length(y.step))
  {
    # print(q)
    
    p[[q]] <- matrix(NA, ncol=2, nrow=length(x.step))
    
    for(i in 1:length(x.step))
    {
      rc <- crop(r, extent(c(x.step[i], x.step[i]+res, y.step[q]-res, y.step[q])))
      rc <- abs(rc - getValues(ag, q)[i])
      
      #find region with minumum difference from mean
      rc2 <- aggregate(rc, fact=fact2, fun=sum)
      rc2[rc2 > minValue(rc2)] <- NA
      rc2 <- trim(rc2)
      
      rc <- crop(rc, extent(rc2))
      
      coord <- rbind(c(xFromCol(ag, i), yFromRow(ag, q)), xyFromCell(rc, cell=which.min(rc)))
      
      if(nrow(coord) > 2 & nrow(coord) <= 1001)
      {
        d <- distm(coord, fun=distGeo)
        diag(d) <- NA
        p[[q]][i,] <- coord[which.min(d[,1]),]
      }
      
      if(nrow(coord) <= 2)
      {
        p[[q]][i,] <- coord[2,]
      }
      
      if(nrow(coord) > 1001)
      {
        coord <- coord[c(1, sample(2:nrow(coord), size = 1000)),]
        d <- distm(coord, fun=distGeo)
        diag(d) <- NA
        p[[q]][i,] <- coord[which.min(d[,1]),]
      }
      
    }
  }
  
  cat("", "\n", "Done", "\n")
  p <- do.call(rbind.data.frame, p)
  colnames(p) <- c("X", "Y")
  return(p)
}
