# ep 4

#need to reload HARV_DSM
DSM_HARV <- 
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV_df <- as.data.frame(DSM_HARV, xy = TRUE)

names(DSM_HARV_df)[names(DSM_HARV_df) == 'HARV_dsmCrop'] <- 'Elevation'
# we should already have dataframes for 
# HARV_DTM and HARV_DSM

# Terrain
# Think "Treetops"
ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# Surface
# Think "Bare" surface
ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, fill = Elevation)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


# do math to create canopy height model
CHM_HARV <- DSM_HARV - DTM_HARV
CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

#check distribution of values
ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))

# challenge
min(HARV_CHM_df$layer, na.rm = TRUE)

ggplot(HARV_CHM_df) +
  geom_histogram(aes(layer))

ggplot(HARV_CHM_df) +
  geom_histogram(aes(layer), colour="black", 
                 fill="darkgreen", bins = 6)

# the above has auto-breaks. we want to specify our own.
custom_bins <- c(0, 10, 20, 30, 40)
HARV_CHM_df <- HARV_CHM_df %>%
  mutate(canopy_discrete = cut(layer, breaks = custom_bins))

ggplot() +
  geom_raster(data = HARV_CHM_df , aes(x = x, y = y,
                                       fill = canopy_discrete)) + 
  scale_fill_manual(values = terrain.colors(4)) + 
  coord_quickmap()

# this is the second way to do raster math: an overlay
HARV_CHM_ov <- overlay(HARV_DSM,
                       HARV_DTM,
                       fun = function(r1, r2) { return( r1 - r2) })

HARV_CHM_ov_df <- as.data.frame(HARV_CHM_ov, xy = TRUE)

ggplot() +
  geom_raster(data = HARV_CHM_ov_df, 
              aes(x = x, y = y, fill = layer)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()


# you'll see these are the same.
max(HARV_CHM_ov_df$layer, na.rm = TRUE)
max(HARV_CHM_df$layer, na.rm = TRUE)

# save our work
# this object name might be wrong 
# in the lesson!
writeRaster(HARV_CHM_ov, "HARV_CHM.tiff",
            format="GTiff",
            overwrite=TRUE,
            NAflag=-9999)
#do we want to make an outputs folder? 