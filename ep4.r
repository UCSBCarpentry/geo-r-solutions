# ep 4

# we should already have dataframes for 
# HARV_DTM and HARV_DSM

# Terrain
# Think "Treetops"
ggplot() +
  geom_raster(data = HARV_DTM_df , 
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# Surface
# Think "Bare" surface
ggplot() +
  geom_raster(data = HARV_DSM_df , 
              aes(x = x, y = y, fill = Altitude)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


# do math to create canopy height model
HARV_CHM <- HARV_DSM - HARV_DTM
HARV_CHM_df <- as.data.frame(HARV_CHM, xy = TRUE)

ggplot() +
  geom_raster(data = HARV_CHM_df , 
              aes(x = x, y = y, fill = layer)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

ggplot(HARV_CHM_df) +
  geom_histogram(aes(layer))

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
writeRaster(CHM_ov_HARV, "HARV_CHM.tiff",
            format="GTiff",
            overwrite=TRUE,
            NAflag=-9999)
