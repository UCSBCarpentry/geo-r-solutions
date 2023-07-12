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
  geom_sf(data = country_boundary_US, color = "gray18", size = 2) +
  geom_sf(data = state_boundary_US, color = "gray40") +
  ggtitle("Map of Contiguous US State Boundaries") +
  coord_sf()
# Kristi comment, I don't think the country border is any darker or thicker

