# geospatial extras

# Kristi's attempt at a Rayshader tutorial
# Trying to figure out which DSM is the best fit 
# ugh hungry 

# To install the latest version from Github:
# Website is: https://www.rayshader.com/
# Set the working directory first.
install.packages("devtools")
devtools::install_github("tylermorganwall/rayshader")

DSM_HARV_Cropped <- crop(x = DSM_HARV, y = aoi_boundary_HARV)

DSM_HARV_matrix = raster_to_matrix(DSM_HARV_Cropped)
DSM_HARV_matrix %>% 
  sphere_shade(texture = "unicorn") %>%
  plot_map()

#add sun angle 
DSM_HARV_matrix %>% 
  sphere_shade(sunangle = 45, texture = "imhof4") %>%
  plot_map()
