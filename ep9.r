# ep 9
# Handling Spatial projections and CRS 

# we will use census data for this portion, read in the following line: 
state_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp") %>%
  st_zm()

# Plot the U.S. States Data: 
ggplot() +
  geom_sf(data = state_boundary_US) +
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()

# create a boundary layer of the United States to make it look nicer. 
# Import US boundary dissolved states
country_boundary_US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp") %>%
  st_zm()


# Overlay both vector files to create a nice state/country map
# Make the country border slightly thicker to differentiate the country vs states
ggplot() +
  geom_sf(data = state_boundary_US, color = "gray60") +
  geom_sf(data = country_boundary_US, color = "black",alpha = 0.25,size = 5)
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()
  
# Kristi comment, I don't think the country border is any darker or thicker
# okay so after some testing, the shapefiles aren't alpha so making one darker or bolder
# won't do anything. The state boundary file is masking the country boundary.
# update: its also not working in the lesson 

# Add CRS to each object
st_crs(point_HARV)$proj4string


#Check the CRS of the state and country boundary objects:
st_crs(state_boundary_US)$proj4string

st_crs(country_boundary_US)$proj4string

## CRS Units - View Object Extent
# first look at the extent of the study site at our tower location
st_bbox(point_HARV)
# then the state boundary data
st_bbox(state_boundary_US)

#Notice they are quite different. One is in larger numbers whil the other is in smaller numbers
#point_HARV is represented in UTM, while the state boundary is in decimal degrees

#Despite the CRS difference, ggplot can plot them together
#Automatically converts all object to the same CRS before plotting. 
#Plot US State, Boundary, and point_HARV together

ggplot() +
  geom_sf(data = country_boundary_US, size = 2, color = "gray18") +
  geom_sf(data = state_boundary_US, color = "gray40") +
  geom_sf(data = point_HARV, shape = 19, color = "purple") +
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()

## Challenge DIY multiple layers of spatial data 
## 1. Import North Eastern United States boundary layer 
## 2. Layer the Tower onto the plot 
## 3. Add a title 
## 4. Add a legend that shows the state boundary and the tower location point

NE.States.Boundary.US <- st_read("data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp") %>%
  st_zm()

ggplot() +
  geom_sf(data = NE.States.Boundary.US, aes(color ="color"),
          show.legend = "line") +
  scale_color_manual(name = "", labels = "State Boundary",
                     values = c("color" = "gray18")) +
  geom_sf(data = point_HARV, aes(shape = "shape"), color = "purple") +
  scale_shape_manual(name = "", labels = "Fisher Tower",
                     values = c("shape" = 19)) +
  ggtitle("Fisher Tower Harvard Forest") +
  theme(legend.background = element_rect(color = NA)) +
  coord_sf()
