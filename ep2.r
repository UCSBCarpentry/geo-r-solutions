# Geospatial R
# episode 2: Classified rasters

# library(raster)
# library(rgdal)
library(ggplot2)
library(dplyr)

ls()
# insert remaking of objects
# just in case
# DSM_HARV
# DSM_HARV_df


# our existing dataframe
DSM_HARV_df

# red / green
# Green if you are still trying to run along


# mutate into bins
# 3 equal breaks
DSM_HARV_df <- DSM_HARV_df %>%
  mutate(fct_elevation = cut(Elevation, breaks = 3))

# now you will see a 4th variable
str(DSM_HARV_df)

ggplot() +
  geom_bar(data = DSM_HARV_df, aes(fct_elevation))

unique(DSM_HARV_df$fct_elevation)

# how many pixels in each class?
DSM_HARV_df %>%
  group_by(fct_elevation) %>%
  count()

# mutate into your own specified bins
custom_bins <- c(300, 350, 400, 450)
str(custom_bins)
DSM_HARV_df <- DSM_HARV_df %>%
  mutate(fct_elevation_2 = cut(Elevation, breaks = custom_bins))

unique(DSM_HARV_df$fct_elevation_2)

# this highlights the few over 400.
# like we did visually previously
ggplot() +
  geom_bar(data = DSM_HARV_df, aes(fct_elevation_2))

# and get the count of pixels in each bin
DSM_HARV_df %>%
  group_by(fct_elevation_2) %>%
  count()

# map it
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  coord_quickmap()

# let's talk aesthetics
# that default color scheme doesn't work so well.
# try this one:
terrain.colors(3)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = terrain.colors(3)) + 
  coord_quickmap()



# save your colors in an object for re-use
my_col <- terrain.colors(3)

# run the plot again, but 
# add a title to the legend
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col, name = "Elevation") + 
  coord_quickmap()

# this one's not complete in the lesson: x and y labels:
ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col, 
                    name="Elevation") + 
  xlab("Easting") + 
  ylab("Northing") +
  coord_quickmap()

# ##################
# challenge plot
# Create a plot of the Harvard Forest DSM
# that has:
  
#  Six classified ranges of values (break points) 
#  that are evenly divided among the range of pixel values.
#
#   Axis labels.
#   A plot title.

DSM_HARV_df <- DSM_HARV_df  %>%
  mutate(fct_elevation_6 = cut(Elevation, breaks = 6)) 

my_col <- terrain.colors(6)

ggplot() +
  geom_raster(data = DSM_HARV_df , aes(x = x, y = y,
                                       fill = fct_elevation_6)) + 
  scale_fill_manual(values = my_col, name = "Elevation") + 
  ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") + 
  coord_quickmap()


# layering rasters
DSM_hill_HARV <-
  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

DSM_hill_HARV
DSM_hill_HARV_df <- as.data.frame(DSM_hill_HARV, xy = TRUE) 
str(DSM_hill_HARV_df)

# plot that with no legend
ggplot() +
  geom_raster(data = DSM_hill_HARV_df,
              aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  scale_alpha(range =  c(0.15, 0.65), guide = "none") + 
  coord_quickmap()

# the top layer needs an alpha if you hope to see it.
# plots build in the order you call the geom's
ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, 
                  fill = Elevation)) + 
  geom_raster(data = DSM_hill_HARV_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_c() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Elevation with hillshade") +
  coord_quickmap()
#fill is still Elevation, not HARV_dsmCrop

###################################
# challenge map: do it with SJER
# these all work, but these aren't the
# names from the solution -- they are the old names


# CREATE DSM MAPS

# import DSM data
DSM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# convert to a df for plotting
DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)

# import DSM hillshade
DSM_hill_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmHill.tif")
# convert to a df for plotting
DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy = TRUE)

# Build Plot
# yess it should be tall and skinny
ggplot() +
  geom_raster(data = DSM_SJER_df , 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop,
                  alpha = 0.8)
  ) + 
  geom_raster(data = DSM_hill_SJER_df, 
              aes(x = x, y = y, 
                  alpha = SJER_dsmHill)
  ) +
  scale_fill_viridis_c() +
  guides(fill = guide_colorbar()) +
  scale_alpha(range = c(0.4, 0.7), guide = "none") +
  # remove grey background and grid lines
  theme_bw() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") +
  ggtitle("DSM with Hillshade") +
  coord_quickmap()


# CREATE DTM MAP
# import DTM
# think: T = Treetops.Isn't T terrain, not trees?
DTM_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
DTM_SJER_df <- as.data.frame(DTM_SJER, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- rast("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
DTM_hill_SJER_df <- as.data.frame(DTM_hill_SJER, xy = TRUE)

ggplot() +
  geom_raster(data = DTM_SJER_df ,
              aes(x = x, y = y,
                  fill = SJER_dtmCrop,
                  alpha = 2.0)
  ) +
  geom_raster(data = DTM_hill_SJER_df,
              aes(x = x, y = y,
                  alpha = SJER_dtmHill)
  ) +
  scale_fill_viridis_c() +
  guides(fill = guide_colorbar()) +
  scale_alpha(range = c(0.4, 0.7), guide = "none") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ggtitle("DTM with Hillshade") +
  coord_quickmap()


