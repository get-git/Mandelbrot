library(raster)
library(parallel)

limx  <- c(-1.259, -1.258)
limy  <- c(0.382, 0.383)
res   <- 0.0000005
stepx <- seq(limx[1], limx[2], by = res)
stepy <- seq(limy[1], limy[2], by = res)
pGrid <- as.matrix(expand.grid(stepx, stepy))

planeProcess <- function(a, b, maxIter = 50){
    n <- 0
    x <- 0
    y <- 0
    distan <- 0
    while(n < maxIter & distan < 4){
        n <- n + 1
        newx <- a + x^2 - y^2
        newy <- b + 2 * x * y
        distan <- newx^2 + newy^2
        x <- newx
        y <- newy
    }
    if(distan < 4){
        return(maxIter + 1) # black colour
    } else {
        return(n)
    }
}

if(Sys.info()["sysname"] == "Linux"){
    iterCols <- mcmapply(planeProcess, pGrid[,1], pGrid[,2], mc.cores = detectCores())
} else {
    cl <- makeCluster(detectCores())
    iterCols <- clusterMap(cl, planeProcess, pGrid[,1], pGrid[,2])
    stopCluster(cl)
}

pGrid <- cbind(pGrid, iterCols)

set.seed(2) # sets the random numver generator for color selection.
maxIter <- 50
rainCol <- c(sample(rainbow(maxIter), maxIter), "#000000")

plot(pGrid[,1],
     pGrid[,2],
     xlim = limx,
     ylim = limy,
     col  = rainCol[pGrid[,3]],
     pch  = ".")

## save out objects
saveRDS(pGrid, "./pGrid_mandel.RDS")
