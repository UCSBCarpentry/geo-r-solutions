# episode 5
# geospatial with R

# open a single band of a multi-band image:
HARV_RGB_band1 <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

HARV_RGB_band1_df  <- as.data.frame(HARV_RGB_band1, xy = TRUE)

#where did HARV_RGB_Ortho come from?
#is it HARV_RGB_Ortho_1?
ggplot() +
  geom_raster(data = HARV_RGB_band1_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_1)) + 
  coord_quickmap()

HARV_RGB_band1

HARV_RGB_band2 <-  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", band = 2)

HARV_RGB_band2_df <- as.data.frame(HARV_RGB_band2, xy = TRUE)

# similarly boring and familiar plot
ggplot() +
  geom_raster(data = HARV_RGB_band2_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_1)) + 
  coord_equal()

# multi-bands get called as 'stacks'
HARV_stack <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# we can see all 3 bands:
HARV_stack

HARV_stack_df  <- as.data.frame(HARV_stack, xy = TRUE)

plotRGB(HARV_stack,
        r = 1, g = 2, b = 3)

# stretching out
plotRGB(HARV_stack,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "lin")

plotRGB(HARV_stack,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "hist")



#############################
# challenge raster
GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

HARV_NA <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")
plotRGB(HARV_NA,
        r = 1, g = 2, b = 3)


# bricks are bigger than stacks because they contain the data, they
# don't point to it. This makes
# calculations and drawing faster
HARV_brick <- brick(HARV_stack)
object.size(HARV_stack)
object.size(HARV_brick)

# at this scale, the difference isn't apparet
plotRGB(HARV_brick)


#####
# Great R tip reminder
# methods()
methods(class=class(HARV_stack))

# all the things we can do with an object
methods(class=class(HARV_brick))
