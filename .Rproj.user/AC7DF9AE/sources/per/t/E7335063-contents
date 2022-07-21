library(raster)
library(rgdal)
library(ggplot2)
library(dplyr)

GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

HARV_DSM_info <- capture.output(
  GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
)

HARV_DSM <- 
  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

HARV_DSM

summary(HARV_DSM)

summary(HARV_DSM, maxsamp = ncell(HARV_DSM))

HARV_DSM_df <- as.data.frame(HARV_DSM, xy = TRUE)

str(HARV_DSM_df)

# change the name of the column to better reflect what it is:

names(HARV_DSM_df)[names(HARV_DSM_df) == 'HARV_dsmCrop'] <- 'Altitude'

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = Altitude)) +
  scale_fill_viridis_c() +
  coord_quickmap()

crs(HARV_DSM)

# deal with NA's

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = Altitude)) +
  scale_fill_viridis_c(na.value = 'deeppink') +
  coord_quickmap()

# no value = -9999
HARV_DSM_info

summary(HARV_DSM_df)

# this shows our current raster doesn't have any.
summary(HARV_DSM)

# dealing with bad values
# lesson shows a figure that it doesn't make.
ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = Altitude)) +
  scale_fill_viridis_c(Altitude > 400 = 'deeppink') +
  coord_quickmap()
