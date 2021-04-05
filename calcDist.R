library(raster)
library(parallel)

## read in mandelbrot matrix
pGrid <- readRDS("./pGrid_mandel.RDS")

## write raster of set
rFrac <- pGrid
rFrac <- rasterFromXYZ(rFrac)
plot(rFrac)
writeRaster(rFrac, "./raster_mandel.tif", overwrite = T)

## make distance matrix from set
dFrac <- rFrac
dFrac[dFrac != 51] <- 1
dFrac[dFrac == 51] <- NA
dBFra <- boundaries(dFrac, classes = F)

pix  <- rasterToPoints(dBFra)
pixB <- pix[pix[,3] == 1, 1:2]
pixI <- pix[pix[,3] == 0, 1:2]

findMinDist <- function(x, y, border = pixB){
    min(sqrt((x - pixB[,1])^2 + (y - pixB[,2])^2))
}

pixD <- mcmapply(findMinDist, pixI[,1], pixI[,2],
                 border = pixB, mc.cores = detectCores())

saveRDS(pixD, "dist.RDS")

dFrac <- cbind(pixI, pixD)
dFrac <- rasterFromXYZ(dFrac)
writeRaster(dFrac, "./raster_distance_mandel.tif", overwrite = T)


install.packages("raster")
