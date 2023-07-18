# Episode 3
# geospatial solutions
library(ggplot2)
library(dplyr)
library(terra)

# helpful R command to see all the objects in memory
ls()

# we made a DTM for SJER. Now let's make one for HARV
DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DTM_hill_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")
DTM_HARV_df <- as.data.frame(DTM_HARV, xy = TRUE)
DTM_hill_HARV_df <- as.data.frame(DTM_hill_HARV, xy = TRUE)

str(DTM_HARV_df)
str(DTM_hill_HARV_df)

# this one is intentionally wrong
# crazy stretch
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# each one plots independently
ggplot() +
  geom_raster(data = DTM_HARV_df,
              aes(x = x, y = y,
                  fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

ggplot() +
  geom_raster(data = DTM_hill_HARV_df,
              aes(x = x, y = y,
                  alpha = HARV_DTMhill_WGS84)) + 
  coord_quickmap()

# Exercise
######################################
# we could have figured this out first
# (read the first line)
crs(DTM_HARV, parse = TRUE)
crs(DTM_hill_HARV, parse = TRUE)

(DTM_HARV)
(DTM_hill_HARV)


# project can be a copy and paste operation
# projectRaster(RasterObject, crs = CRSToReprojectTo)

DTM_hill_UTMZ18N_HARV <- project(DTM_hill_HARV,
                                 crs(DTM_HARV))


crs(DTM_hill_UTMZ18N_HARV, parse = TRUE)

#compare to before
# now they are the same
crs(DTM_hill_HARV, parse = TRUE)
crs(DTM_hill_UTMZ18N_HARV, parse = TRUE)


# Raster resolution:
# resolution has a slight mismatch
res(DTM_hill_UTMZ18N_HARV)
res(DTM_HARV)

# so this still doesn't work 
DTM_hill_UTMZ18N_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy=TRUE)
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


# tell R to force newly reprojected raster to 1m x 1m resolution
DTM_hill_UTMZ18N_HARV <- project(DTM_hill_UTMZ18N_HARV,
                                 crs(DTM_HARV),
                                 res = res(DTM_HARV))
res(DTM_hill_UTMZ18N_HARV)


# To plot in ggplot, make a dataframe
DTM_hill_HARV_2_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy = TRUE)

# now it will overlay!!!
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_2_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# even though the extents
# are different. Sometimes differing
# extents will mess you up
ext(DTM_hill_UTMZ18N_HARV)
ext(DTM_hill_HARV)



# take home message:
# projection and resolution have
# to match!
# extent may be optional

##############################
# challenge: make an overlay for SJER plotting digital terrain model
# import DSM
DSM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# import DSM hillshade
DSM_hill_SJER_WGS <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

# reproject raster
# This should be DSM not DTM right? Typo in challenge. 
DSM_hill_UTMZ18N_SJER <- project(DSM_hill_SJER_WGS,
                                crs(DSM_SJER),
                                res = 1)

# convert to data.frames
DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)
DSM_hill_SJER_df <- as.data.frame(DSM_hill_UTMZ18N_SJER, xy = TRUE)

# and now our grand-finale map
ggplot() +
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)
  ) +
  geom_raster(data = DSM_SJER_df, 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop, alpha = 0.8)
  ) + 
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()
