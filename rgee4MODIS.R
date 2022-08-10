library(rgee)
library(sf)
library(stars)
ee_Initialize(user = "antony.barja@upch.pe",drive = T)

mod09q1 <- ee$ImageCollection$
  Dataset$
  MODIS_006_MOD09Q1$
  filterDate("2022-06-01","2022-06-08")

shp <- st_read("test1.shp") %>% st_geometry() %>% sf_as_ee()
start <- ee$Date("2022-06-01")
end <- ee$Date("2022-06-08")
filter <-mod09q1$filterDate(start,end)
img <- filter$first()$clip(shp)
img_b1<-img$select(c("sur_refl_b01"))
img_b2<-img$select(c("sur_refl_b02"))
img_qa<-img$select(c("QA"))

Map$setCenter(-46.8,-12.8, zoom = 7)
Map$addLayer(
  img,
  visParams = list(
    bands = c("sur_refl_b01", "sur_refl_b02"),
    min =100,
    max = 8000,
    gamma = c(1.9,1.7)),
  "False Color Image"
  )

ee_raster <- ee_as_raster(
  image = img_b1$reproject('EPSG:4326', NULL, 500),
  region = shp$geometry(),
  dsn = "/home/am/Imágenes/modis2.tif",
  via = "drive"
  )
