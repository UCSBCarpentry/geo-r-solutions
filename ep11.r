# episode 11
# Manipulate raster data (even more)

#In case we need to remake/reload the environment
# HARV_DSM <- 
#  +   raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
# HARV_DSM_df <- as.data.frame(HARV_DSM, xy = TRUE)
# names(HARV_DSM_df)[names(HARV_DSM_df) == 'HARV_dsmCrop'] <- 'Elevation'
#
# HARV_DTM <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
# HARV_DTM_df <- as.data.frame(HARV_DTM, xy = TRUE)
#
# HARV_CHM <- HARV_DSM - HARV_DTM
# HARV_CHM_df <- as.data.frame(HARV_CHM, xy = TRUE)
# names(HARV_CHM_df)[names(HARV_CHM_df) == 'layer'] <- 'Elevation'
#
# aoi_boundary_HARV <- st_read(
# +   "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")
# HARV_lines <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")
#
# country_boundary_US <- st_read(
# "data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp") %>%
# +   st_zm()
#
# state_boundary_US <- st_read(
# "data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>%
# +   st_zm()

## Crop a Raster to a Vector Extent
# Its more efficient to crop a raster to the extent of our study area to reduce file sizes 

# Using the Crop() function.
# R will use ht eextent of the spatial object as the cropping boundary

#Need to make sure layers is replaced with elevation in CHM_df layer
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x = x, y = y, fill = Elevation)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()

#Now subset with cropping operation
HARV_CHM_Cropped <- crop(x = HARV_CHM, y = aoi_boundary_HARV)
HARV_CHM_Cropped_df <- as.data.frame(HARV_CHM_Cropped, xy = TRUE)
names(HARV_CHM_Cropped_df)[names(HARV_CHM_Cropped_df) == 'layer'] <- 'Elevation'

#this plot will show the full CHM extent (green) is much larger than the 
#cropped raster.
ggplot() +
  geom_sf(data = st_as_sfc(st_bbox(HARV_CHM)), fill = "green",
          color = "green", alpha = .2) +
  geom_raster(data = HARV_CHM_Cropped_df,
              aes(x = x, y = y, fill = Elevation)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

#now plot the cropped images
ggplot() +
  geom_raster(data = HARV_CHM_Cropped_df,
              aes(x = x, y = y, fill = Elevation)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()
# I used the CHM calculated by raster math and the output is more green
# than the output in the lesson. I'm wondering if its because they imported
# the layer instead of using the raster math version. (consistency ugh)
