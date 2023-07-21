# episode 11
# Manipulate raster data (even more)

#In case we need to remake/reload the environment
DSM_HARV <- 
  +   rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV_df <- as.data.frame(DSM_HARV, xy = TRUE)
names(DSM_HARV_df)[names(DSM_HARV_df) == 'HARV_dsmCrop'] <- 'Elevation'
#
DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DTM_HARV_df <- as.data.frame(DTM_HARV, xy = TRUE)
#

# read in a clean CHM if you need to. Don't use the layer made in episode 4
CHM_HARV<- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
CHM_HARV_df <- as.data.frame(HARV_CHM, xy = TRUE)
#names(CHM_HARV_df)[names(CHM_HARV_df) == 'HARV_chmCrop'] <- 'Elevation'
#
aoi_boundary_HARV <- st_read( "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")
lines_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp")
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")
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
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()

#Now subset with cropping operation
CHM_HARV_Cropped <- crop(x = CHM_HARV, y = aoi_boundary_HARV)
CHM_HARV_Cropped_df <- as.data.frame(CHM_HARV_Cropped, xy = TRUE)
#names(HARV_CHM_Cropped_df)[names(HARV_CHM_Cropped_df) == 'HARV_chmCrop'] <- 'Elevation'

#this plot will show the full CHM extent (green) is much larger than the 
#cropped raster.
ggplot() +
  geom_sf(data = st_as_sfc(st_bbox(CHM_HARV)), fill = "green",
          color = "green", alpha = .2) +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

#now plot the cropped images
ggplot() +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()


# Look at the extent of all of the objects: 
st_bbox(CHM_HARV)

st_bbox(CHM_HARV_Cropped)

st_bbox(aoi_boundary_HARV)

st_bbox(plot_locations_sp_HARV)
#this is a lot of stuff in our global environment

## Challenge DIY - Crop to vector points extent
# 1. Crop the canopy height model to the extent of the plot locations
# 2. Plot the vegetation plot points on top of the canopy height model

CHM_plots_HARVcrop <- crop(x = CHM_HARV, y = plot_locations_sp_HARV)

CHM_plots_HARVcrop_df <- as.data.frame(CHM_plots_HARVcrop, xy = TRUE)
#are we not going to change the fill to layername to elevation here?
#also naming is all over the place 

ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = plot_locations_sp_HARV) +
  coord_sf()

# Defining a new extent 
# use the ext() function to define an extent for a cropping boundary

new_extent <- ext(732161.2, 732238.7, 4713249, 4713333)
class(new_extent)
# where did this extent come from?


CHM_HARV_manual_cropped <- crop(x = CHM_HARV, y = new_extent)

CHM_HARV_manual_cropped_df <- as.data.frame(CHM_HARV_manual_cropped, xy = TRUE)

ggplot() +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  geom_raster(data = CHM_HARV_manual_cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()

# Extract raster pixels using vector polygons
# extract() requires
# the raster that we wish to extract from
# the vector layer with the polygons that we want to use as boundar(ies)

#extract canopy values located within the aoi_boundary polygon
tree_height <- extract(x = CHM_HARV, y = aoi_boundary_HARV, raw = FALSE)

#str(tree_height_df)
#missing dataframe 
#tree_height_df <- as.data.frame(tree_height, xy = TRUE)
#str(tree_height_df)

ggplot() +
  geom_histogram(data = tree_height, aes(x = HARV_chmCrop)) +
  ggtitle("Histogram of CHM Height Values (m)") +
  xlab("Tree Height") +
  ylab("Frequency of Pixels")

summary(tree_height$HARV_chmCrop)

## Summarize extracted raster values
mean_tree_height_AOI <- extract(x = CHM_HARV, y = aoi_boundary_HARV,
                            fun=mean)
mean_tree_height_AOI

## Extracting data using x,y, locations
mean_tree_height_tower <- extract(x = CHM_HARV,
                                  y = st_buffer(point_HARV, dist = 20),
                                  fun = mean)
mean_tree_height_tower

## Challenge: Extract raster height values for plot locations
# 1. use plot locations: plot_locations_sp_HARV to extract av tree height within 20m
#    of each vegetation plot 
# 2. create a plot, specifically a bar plot showing mean tree height of each area

# Extract data at each plot location
mean_tree_height_plots_HARV <- extract(x = CHM_HARV, 
                                       y = st_buffer(plot_locations_sp_HARV,
                                                     dist = 20),
                                       fun = mean)
mean_tree_height_plots_HARV

#plot data
ggplot(data = mean_tree_height_plots_HARV, aes(ID, HARV_chmCrop)) +
  geom_col()+
  ggtitle("Mean Tree Height at each Plot")+
  xlab("Plot ID")+
  ylab("Tree Height(m)")
