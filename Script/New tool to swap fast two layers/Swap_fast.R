#'author: Antony Barja
# Loading packages
library(leaflet.extras2)
library(tidyverse)
library(rgee) # New version v.1.0.5

# Starting GEE in R  
ee_Initialize()
box <- ee$Geometry$Rectangle(
  coords = c(-71.72,-15.67,-71.67,-15.64),
  proj = "EPSG:4326",
  geodesic = FALSE)

id_img <- 'COPERNICUS/S2_SR/20200623T145729_20200623T150542_T18LZH'
sen2 <- ee$Image(id_img)$
  clip(box)

# Definition of color palettes
viz_rgb <-list(min = 450,
               max =3500,
               bands= c('B8A','B4','B3'),
               gamma = 1.2)

viz_ndvi <- list(palette = c(
  "#d73027", "#f46d43", 
  "#fdae61", "#fee08b",
  "#d9ef8b", "#a6d96a",
  "#66bd63", "#1a9850")
)

# RGB with NDVI
Map$centerObject(box)
sen2_rgb <- Map$addLayer(sen2, visParams = viz_rgb, name = "a1")
sen2_ndvi <- sen2$normalizedDifference(c('B8A','B4')) %>%
  Map$addLayer(visParams = viz_ndvi, name = "a2") 

# Displaying the two scenas
sen2_rgb | sen2_ndvi