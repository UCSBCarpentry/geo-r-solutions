# helpful R command to see all the objects in memory
ls()

# we made a DTM for SJER. Now let's make one for HARV
HARV_DTM <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
HARV_DTM_hill <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")
HARV_DTM_df <- as.data.frame(HARV_DTM, xy = TRUE)
HARV_DTM_hill_df <- as.data.frame(HARV_DTM_hill, xy = TRUE)

# this one is intentionally wrong
ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = HARV_DTM_hill_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# each one plots independently
ggplot() +
  geom_raster(data = HARV_DTM_df,
              aes(x = x, y = y,
                  fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

ggplot() +
  geom_raster(data = HARV_DTM_hill_df,
              aes(x = x, y = y,
                  alpha = HARV_DTMhill_WGS84)) + 
  coord_quickmap()

# we could have figured this out first
# (read the first line)
crs(HARV_DTM)
crs(HARV_DTM_hill)

(HARV_DTM)
(HARV_DTM_hill)


# project can be a copy and paste operation
# projectRaster(RasterObject, crs = CRSToReprojectTo)

HARV_DTM_hill_reprojected <- projectRaster(HARV_DTM_hill,
                                           crs = crs(HARV_DTM))


(HARV_DTM_hill_reprojected)
(HARV_DTM)


# this still doesn't work because the EXTENTS don't match
HARV_DTM_hill_reprojected_df <- as.data.frame(HARV_DTM_hill_reprojected, xy=TRUE)
ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = HARV_DTM_hill_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# you can see that
extent(HARV_DTM_hill_reprojected)
extent(HARV_DTM_hill)

# easier to determine:
extent(HARV_DTM_hill_reprojected) == extent(HARV_DTM_hill)

# another thing that doesn't match after reprojection is pixel size
res(HARV_DTM_hill_reprojected)
res(HARV_DTM)

# force them to match
HARV_DTM_hill_reprojected <- projectRaster(HARV_DTM_hill,
                                           crs = crs(HARV_DTM),
                                           res = res(HARV_DTM)) 

# make a dataframe
HARV_DTM_hill_2_df <- as.data.frame(HARV_DTM_hill_reprojected, xy = TRUE)

ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = HARV_DTM_hill_2_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# take home message:
# projection, extent, and resolution all have
# to match!


##############################
# challenge: make an overlay for SJER
# import DSM
SJER_DSM <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# import DSM hillshade
SJER_DSM_hill_WGS <-
  raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

# reproject raster
SJER_DSM_hill_reprojected <- projectRaster(SJER_DSM_hill_WGS,
                                           crs = crs(SJER_DSM),
                                           res = 1)

# convert to data.frames
SJER_DSM_df <- as.data.frame(SJER_DSM, xy = TRUE)

SJER_DSM_hill_df <- as.data.frame(SJER_DSM_hill_reprojected, xy = TRUE)

ggplot() +
  geom_raster(data = SJER_DSM_hill_df, 
              aes(x = x, y = y, 
                  alpha = SJER_DSMhill_WGS84)
  ) +
  geom_raster(data = SJER_DSM_df, 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop, alpha = 0.8)
  ) + 
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()
