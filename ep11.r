# episode 11
# Manipulate raster data (even more)

#In case we need to remake/reload the environment
HARV_DSM <- 
  +   raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
HARV_DSM_df <- as.data.frame(HARV_DSM, xy = TRUE)
names(HARV_DSM_df)[names(HARV_DSM_df) == 'HARV_dsmCrop'] <- 'Elevation'
#
# HARV_DTM <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
# HARV_DTM_df <- as.data.frame(HARV_DTM, xy = TRUE)
#
# HARV_CHM <- HARV_DSM - HARV_DTM
HARV_CHM <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
HARV_CHM_df <- as.data.frame(HARV_CHM, xy = TRUE)
names(HARV_CHM_df)[names(HARV_CHM_df) == 'HARV_chmCrop'] <- 'Elevation'
#
aoi_boundary_HARV <- st_read( "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")
HARV_lines <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")
#
country_boundary_US <- st_read(
"data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp") %>%
+   st_zm()
#
state_boundary_US <- st_read(
"data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>%
+   st_zm()

## Crop a Raster to a Vector Extent
# Its more efficient to crop a raster to the extent of our study area to reduce file sizes 

# Using the Crop() function.
# R will use the extent of the spatial object as the cropping boundary

#Need to make sure layers is replaced with elevation in CHM_df layer
ggplot() +
  geom_raster(data = HARV_CHM_df, aes(x = x, y = y, fill = Elevation)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()

#Now subset with cropping operation
HARV_CHM_Cropped <- crop(x = HARV_CHM, y = aoi_boundary_HARV)
HARV_CHM_Cropped_df <- as.data.frame(HARV_CHM_Cropped, xy = TRUE)
names(HARV_CHM_Cropped_df)[names(HARV_CHM_Cropped_df) == 'HARV_chmCrop'] <- 'Elevation'

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
## update: yeah they imported the one in the data folder

# Look at the extent of all of the objects: 
st_bbox(HARV_CHM)

st_bbox(HARV_CHM_Cropped)

st_bbox(aoi_boundary_HARV)

st_bbox(HARV_plot_locations_sp)
#this is a lot of stuff in our global environment

## Challenge DIY - Crop to vector points extent
# 1. Crop the canopy height model to the extent of the plot locations
# 2. Plot the vegetation plot points on top of the canopy height model

HARVcrop_CHM_plots <- crop(x = HARV_CHM, y = HARV_plot_locations_sp)

HARVcrop_CHM_plots_df <- as.data.frame(HARVcrop_CHM_plots, xy = TRUE)
#are we not going to change the fill to layername to elevation here?
#also naming is all over the place 

ggplot() +
  geom_raster(data = HARVcrop_CHM_plots_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = HARV_plot_locations_sp) +
  coord_sf()

# Defining a new extent 
# use the ext() function to define an extent for a cropping boundary

new_extent <- extent(732161.2, 732238.7, 4713249, 4713333)
class(new_extent)
# where did this extent come from?
# also not working. Used extent from raster package instead of ext from terra

# Output:
# [1]Extent
# attr("package")
# [1]raster


HARV_CHM_manual_cropped <- crop(x = HARV_CHM, y = new_extent)
# error: cant get extent object from argument y

HARV_CHM_manual_cropped_df <- as.data.frame(HARV_CHM_manual_cropped, xy = TRUE)

ggplot() +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  geom_raster(data = HARV_CHM_manual_cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

# Extract raster pixels using vector polygons
# extract() requires
# the raster that we wish to extract from
# the vector layer with the polygons that we want to use as boundar(ies)

#extract canopy values located within the aoi_boundary polygon
tree_height <- extract(x = HARV_CHM, y = aoi_boundary_HARV, raw = FALSE)

#str(tree_height_df)
#missing dataframe 
tree_height_df <- as.data.frame(tree_height, xy = TRUE)
str(tree_height_df)

#even with converting to dataframe, only 1 variable, not two like in the lesson
#reloaded new chm image but still only 1 variable? 

ggplot() +
  geom_histogram(data = tree_height, aes(x = HARV_chmCrop)) +
  ggtitle("Histogram of CHM Height Values (m)") +
  xlab("Tree Height") +
  ylab("Frequency of Pixels")
