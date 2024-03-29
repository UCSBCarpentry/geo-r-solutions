# ep 8
# vector overlays!

# make sure we have the needed libraries
library(sf)
#library(raster)
library(ggplot2)
library(tidyverse)

ls()
# 51 objects at this point!!!

# to stack them up, use
# multiple geom_sf
# they draw in order (ie: first line on the bottom)
ggplot() + 
  geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "grey") +
  geom_sf(data = lines_HARV, aes(color = TYPE), size = 1) +
  geom_sf(data = point_HARV) +
  ggtitle("NEON Harvard Forest Field Site") + 
  coord_sf()

# let's make a better legend
ggplot() + 
  geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "grey") +
  geom_sf(data = lines_HARV, aes(color = TYPE),
          show.legend = "line", size = 1) +
  geom_sf(data = point_HARV, aes(fill = Sub_Type), color = "black") +
  scale_color_manual(values = road_colors) +
  scale_fill_manual(values = "black") +
  ggtitle("NEON Harvard Forest Field Site") + 
  coord_sf()

# name that legend better
ggplot() + 
  geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "grey") +
  geom_sf(data = point_HARV, aes(fill = Sub_Type)) +
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend = "line",
          size = 1) + 
  scale_color_manual(values = road_colors, name = "Line Type") + 
  scale_fill_manual(values = "black", name = "Tower Location") + 
  ggtitle("NEON Harvard Forest Field Site") + 
  coord_sf()

# get help with point symbols
?pch

# I got this off the internet
  par(font=2, mar=c(0.5,0,0,0))
  y=rev(c(rep(1,6),rep(2,5), rep(3,5), rep(4,5), rep(5,5)))
  x=c(rep(1:5,5),6)
  plot(x, y, pch = 0:25, cex=1.5, ylim=c(1,5.5), xlim=c(1,6.5), 
       axes=FALSE, xlab="", ylab="", bg="blue")
  text(x, y, labels=0:25, pos=3)
  par(mar=oldPar$mar,font=oldPar$font )

# shape = 15 is a nice box
  ggplot() +
    geom_sf(data = aoi_boundary_HARV, fill = "grey", color = "grey") +
    geom_sf(data = point_HARV, aes(fill = Sub_Type), shape = 15) +
    geom_sf(data = lines_HARV, aes(color = TYPE),
            show.legend = "line", size = 1) +
    scale_color_manual(values = road_colors, name = "Line Type") +
    scale_fill_manual(values = "black", name = "Tower Location") +
    ggtitle("NEON Harvard Forest Field Site") + 
    coord_sf()
  
# challenge
plot_locations <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")

# we'll need to make a factor
levels(plot_locations$soilTypeOr)

plot_locations$soilTypeOr <- factor(plot_locations$soilTypeOr)

# we'll need 2 colors
levels(plot_locations$soilTypeOr)

#create a new color palette for the soil type
blue_orange <- c("cornflowerblue", "darkorange")

#plot it
ggplot() + 
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend = "line") + 
  geom_sf(data = plot_locations, aes(fill = soilTypeOr), 
          shape = 21, show.legend = 'point') + 
  scale_color_manual(name = "Line Type", values = road_colors,
                     guide = guide_legend(override.aes = list(linetype = "solid", shape = NA))) + 
  scale_fill_manual(name = "Soil Type", values = blue_orange,
                    guide = guide_legend(override.aes = list(linetype = "blank", shape = 21, colour = NA))) + 
  ggtitle("NEON Harvard Forest Field Site") + 
  coord_sf()

# use 2 different symbols to more strongly distinguish
ggplot() + 
  geom_sf(data = lines_HARV, aes(color = TYPE), show.legend = "line", size = 1) + 
  geom_sf(data = plot_locations, aes(fill = soilTypeOr, shape = soilTypeOr),
          show.legend = 'point', size = 3) + 
  scale_shape_manual(name = "Soil Type", values = c(21, 22)) +
  scale_color_manual(name = "Line Type", values = road_colors,
                     guide = guide_legend(override.aes = list(linetype = "solid", shape = NA))) + 
  scale_fill_manual(name = "Soil Type", values = blue_orange,
                    guide = guide_legend(override.aes = list(linetype = "blank", shape = c(21, 22),
                                                             color = blue_orange))) + 
  ggtitle("NEON Harvard Forest Field Site") + 
  coord_sf()

# this doesn't match the lesson
# typo here. in episode 4, the fill is HARV_dsmCrop not chmCrop
# this is wrong in the main lesson, a new CHM layer was read in.
CHM_HARV<- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = lines_HARV, color = "black") +
  geom_sf(data = aoi_boundary_HARV, color = "grey20", size = 1) +
  geom_sf(data = point_HARV, pch = 8) +
  ggtitle("NEON Harvard Forest Field Site w/ Canopy Height Model") + 
  coord_sf()



