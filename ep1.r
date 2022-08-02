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
# here's the code:
DSM_highvals <- reclassify(HARV_DSM, rcl = c(0, 400, NA_integer_, 400, 420, 1L), include.lowest = TRUE)
# ^^^^^^^^
# that's not very elegant at all. There must be a way to get only > 400 and overlay it.

DSM_highvals <- as.data.frame(DSM_highvals, xy = TRUE)
str(DSM_highvals)
# change that name again
names(DSM_highvals)[names(DSM_highvals) == 'HARV_dsmCrop'] <- 'Altitude'

str(DSM_highvals)

ggplot() +
  geom_raster(data = HARV_DSM_df, aes(x = x, y = y, fill = Altitude)) + 
  scale_fill_viridis_c() + 
  # use reclassified raster data as an annotation
  annotate(geom = 'raster', x = DSM_highvals$x, y = DSM_highvals$y, fill = scales::colour_ramp('deeppink')(DSM_highvals$Altitude)) +
  ggtitle("Elevation Data", subtitle = "Highlighting values > 400m") +
  coord_quickmap()

# ^^^^^^
# oddly the error message from this says there's a ton of NA's.
# the reclass must have created a bunch.
# lesson 2 solves this question by creating custom bins.

summary(DSM_highvals)

ggplot() +
  geom_histogram(data = HARV_DSM_df, aes(Altitude))

# skipped making more bins.

# Challenge
# geting info about another raster
GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
