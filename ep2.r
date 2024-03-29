# episode 2. Geospatial R

library(raster)
library(rgdal)
library(ggplot2)
library(dplyr)

# our existing dataframe
HARV_DSM_df

# mutate into bins
HARV_DSM_df <- HARV_DSM_df %>%
  mutate(fct_elevation = cut(Altitude, breaks = 3))

ggplot() +
  geom_bar(data = HARV_DSM_df, aes(fct_elevation))

unique(HARV_DSM_df$fct_elevation)

HARV_DSM_df %>%
  group_by(fct_elevation) %>%
  count()

# mutate into specified bins
custom_bins <- c(300, 350, 400, 450)

HARV_DSM_df <- HARV_DSM_df %>%
  mutate(fct_elevation_2 = cut(Altitude, breaks = custom_bins))

unique(HARV_DSM_df$fct_elevation_2)

# this again highlights the over 400.
ggplot() +
  geom_bar(data = HARV_DSM_df, aes(fct_elevation_2))

# and get the count of pixels in each bin
HARV_DSM_df %>%
  group_by(fct_elevation_2) %>%
  count()

# map it
ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = fct_elevation_2)) + 
  coord_quickmap()

# that default color scheme doesn't work so well.
# try this one:
terrain.colors(3)

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = terrain.colors(3)) + 
  coord_quickmap()

# I was thinking we could get fancy and have one color
# for each unique value, but that would be ridic.
# this takes long enough
# AND it doesn't work that way
ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y,
                                       fill = fct_elevation)) + 
  scale_fill_manual(values = terrain.colors(50)) + 
  coord_quickmap()



# save your colors in an object for re-use
# and add a title to the legend
my_col <- terrain.colors(3)

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col, name = "Elevation") + 
  coord_quickmap()

# this one's not complete in the lesson: x and y labels:
ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y,
                                       fill = fct_elevation_2)) + 
  scale_fill_manual(values = my_col, 
                    name="Elevation") + 
  xlab("Easting") + 
  ylab("Northing") +
  coord_quickmap()


# challenge plot
HARV_DSM_df <- HARV_DSM_df  %>%
  mutate(fct_elevation_6 = cut(Altitude, breaks = 6)) 

my_col <- terrain.colors(6)

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y,
                                       fill = fct_elevation_6)) + 
  scale_fill_manual(values = my_col, name = "Elevation") + 
  ggtitle("Classified Elevation Map - NEON Harvard Forest Field Site") +
  xlab("UTM Easting Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") + 
  coord_quickmap()


# layering rasters
HARV_hill <-
  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")

HARV_hill
HARV_hill_df <- as.data.frame(HARV_hill, xy = TRUE) 
str(HARV_hill_df)

# plot that with no legend
ggplot() +
  geom_raster(data = HARV_hill_df,
              aes(x = x, y = y, alpha = HARV_DSMhill)) + 
  scale_alpha(range =  c(0.15, 0.65), guide = "none") + 
  coord_quickmap()

# the top layer needs an alpha if you hope to see it.
# plots build in the order you call the geom's
ggplot() +
  geom_raster(data = HARV_DSM_df , 
              aes(x = x, y = y, 
                  fill = Altitude)) + 
  geom_raster(data = HARV_hill_df, 
              aes(x = x, y = y, 
                  alpha = HARV_DSMhill)) +  
  scale_fill_viridis_c() +  
  scale_alpha(range = c(0.15, 0.65), guide = "none") +  
  ggtitle("Elevation with hillshade") +
  coord_quickmap()


###################################
# challenge map: do it with SJER
# CREATE DSM MAPS

# import DSM data
SJER_DSM <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")
# convert to a df for plotting
SJER_DSM_df <- as.data.frame(SJER_DSM, xy = TRUE)

# import DSM hillshade
SJER_DSM_hill <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmHill.tif")
# convert to a df for plotting
SJER_DSM_hill_df <- as.data.frame(SJER_DSM_hill, xy = TRUE)

# Build Plot
ggplot() +
  geom_raster(data = SJER_DSM_df , 
              aes(x = x, y = y, 
                  fill = SJER_dsmCrop,
                  alpha = 0.8)
  ) + 
  geom_raster(data = SJER_DSM_hill_df, 
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
# think: T = Treetops.
DTM_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
DTM_SJER_df <- as.data.frame(DTM_SJER, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
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

# CREATE DTM MAP
# import DTM
SJER_DTM <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
SJER_DTM_df <- as.data.frame(SJER_DTM, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
DTM_hill_SJER_df <- as.data.frame(DTM_hill_SJER, xy = TRUE)

ggplot() +
  geom_raster(data = SJER_DTM_df ,
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

