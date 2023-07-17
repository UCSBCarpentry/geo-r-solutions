# episode 5
# geospatial with R

# open a single band of a multi-band image:
RGB_band1_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

RGB_band1_HARV_df  <- as.data.frame(RGB_band1_HARV, xy = TRUE)

#where did HARV_RGB_Ortho come from?
#is it HARV_RGB_Ortho_1?
ggplot() +
  geom_raster(data = RGB_band1_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_1)) + 
  coord_quickmap()

#Challenge: view attributes of band 1
RGB_band1_HARV

RGB_band2_HARV <-  rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", lyrs = 2)

RGB_band2_HARV_df <- as.data.frame(RGB_band2_HARV, xy = TRUE)

# similarly boring and familiar plot
ggplot() +
  geom_raster(data = RGB_band2_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho_2)) + 
  coord_equal()

# multi-bands get called as 'stacks'
RGB_stack_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

# we can see all 3 bands:
RGB_stack_HARV

# view attributes of each band by using index values
RGB_stack_HARV[[2]]

# make a dataframe
RGB_stack_HARV_df  <- as.data.frame(RGB_stack_HARV, xy = TRUE)

str(RGB_stack_HARV_df)

# create histogram of band 1
ggplot()+
  geom_histogram(data=RGB_stack_HARV_df, aes(HARV_RGB_Ortho_1))

#add raster of second band

ggplot()+
  geom_raster(data = RGB_stack_HARV_df,
              aes(x=x, y=y, alpha = HARV_RGB_Ortho_2))+
  coord_quickmap()

# Creating a 3-band image:
plotRGB(RGB_stack_HARV, 
        r = 1, g = 2, b = 3)

## Image stretching 
# stretching out - increase visual contrast of image
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "lin")

plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "hist")



#############################
# challenge raster
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

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
