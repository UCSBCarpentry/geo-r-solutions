# helpful R command to see all the objects in memory
ls()

# we made a DTM for SJER. Now let's make one for HARV
HARV_DTM <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
HARV_DTM_hill <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif")
HARV_DTM_df <- as.data.frame(HARV_DTM, xy = TRUE)
HARV_DTM_hill_df <- as.data.frame(HARV_DTM_hill, xy = TRUE)

# this one is intentionally wrong
# crazy stretch
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

# Exercise
######################################
# we could have figured this out first
# (read the first line)
crs(HARV_DTM, parse = TRUE)
crs(HARV_DTM_hill, parse = TRUE)

(HARV_DTM)
(HARV_DTM_hill)


# project can be a copy and paste operation
# projectRaster(RasterObject, crs = CRSToReprojectTo)

DTM_hill_UTMZ18N_HARV <- project(HARV_DTM_hill,crs(HARV_DTM))


crs(DTM_hill_UTMZ18N_HARV, parse = TRUE)

#compare to before
crs(HARV_DTM_hill, parse = TRUE)

ext(DTM_hill_UTMZ18N_HARV)
ext(HARV_DTM_hill)


#Raster resolution:
res(DTM_hill_UTMZ18N_HARV)

res(HARV_DTM)

# this still doesn't work because the EXTENTS don't match
DTM_hill_UTMZ18N_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy=TRUE)
ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = HARV_DTM_hill_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


#tell R to force newly reprojected raster to 1m x 1m resolution

DTM_hill_UTMZ18N_HARV <- project(HARV_DTM_hill,
                                 crs(HARV_DTM),
                                 res = res(HARV_DTM))
res(DTM_hill_UTMZ18N_HARV)


# To plot in ggplot, make a dataframe
DTM_hill_HARV_2_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, 
                  fill = HARV_dtmCrop)) + 
  geom_raster(data = DTM_hill_HARV_2_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DTMhill_WGS84)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# take home message:
# projection, extent, and resolution all have
# to match!

##############################
# challenge: make an overlay for SJER plotting digital terrain model
# import DSM
SJER_DSM <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# import DSM hillshade
SJER_DSM_hill_WGS <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif")

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
