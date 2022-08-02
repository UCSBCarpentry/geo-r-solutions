# ep 6
# vector data!

# our first new library in a while
library(sf)

# vector files are shapefiles
aoi_boundary_HARV <- st_read(
  "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")

# there are 18 types of shapefiles.
# this one is polygons
st_geometry_type(aoi_boundary_HARV)

# and it has CRS metadata baked into it
st_crs(aoi_boundary_HARV)

# one of those pieces of data is a bounding box
# you will need these in your future life
st_bbox(aoi_boundary_HARV)

# mostly we want to make maps
# this is not a useful map
ggplot() + 
  geom_sf(data = aoi_boundary_HARV, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("AOI Boundary Plot") + 
  coord_sf()


