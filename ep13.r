# Episode 13
# Making publication quality graphics

## Adjusting the Plot Theme

# use 'void' to remove messy x and y labels (if they get in the way and look messy)
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void()

# add a plot title and subtitle. Note this is after the void
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

## Challenge DIY make a bolded plot title 
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df,
              aes(x = x, y = y, fill = value)) +
  facet_wrap(~ variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5))

# Adjusting the color ramp
library(RColorBrewer)
brewer.pal(9, "YlGn")

# pass the color codes with the rampPalette function
green_colors <- brewer.pal(9, "YlGn") %>%
  colorRampPalette()

# Tell how many shades/colors you want, in this case, 20
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))

# Refine Plot and Tile labels
# first remove "_HARV_NDVI_crop" from each label to make them shorter 
names(NDVI_HARV_stack)

raster_names <- names(NDVI_HARV_stack)

raster_names <- gsub("_HARV_ndvi_crop","",raster_names)
raster_names
# Looks like the band names are different from the lesson the "X" at the beginning of 
# each band is missing, so after I remove ^ there are only the first three numbers
# instead of using gsub, use paste0 to tack on "Day" since X isn't part of the actual file name anymore 

raster_names <- paste("Day", raster_names)
raster_names
#I think this workaround did it

labels_names <- setNames(raster_names, unique(NDVI_HARV_stack_df$variable))

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))

#Changing the layout of panels
ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, ncol = 5, 
             labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))

#Challenge: Divergent Color ramps
raster_names  <- gsub("Day","Julian Day", raster_names)
#raster_names if you want to check to make sure you have the correct labels

labels_names <- setNames(raster_names, unique(NDVI_HARV_stack_df$variable))

brown_green_colors <- colorRampPalette(brewer.pal(9, "BrBG"))

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, ncol = 5, labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI - Julian Days", subtitle = "Harvard Forest 2011") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) +
  scale_fill_gradientn(name = "NDVI", colours = brown_green_colors(20))
