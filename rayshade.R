library(raster)
library(rayshader)

## frac <- raster("./raster_mandel.tif")
## frac <- raster::as.matrix(frac * 10)

## frac %>%
##     sphere_shade(texture = "desert") %>%
##     plot_3d(frac)

dFrac <- raster("./raster_distance_mandel.tif")
dFrac <- raster::as.matrix(dFrac * 4e6)

dFrac %>%
    sphere_shade(texture = "desert") %>%
    plot_3d(dFrac)
