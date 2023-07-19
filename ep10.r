# ep 10
# Converting from .csv to a vector layer 
# How to import spatial points stored onto a .csv into an R/sf spatial object 

library(terra)
library(sf)

#Import a new csv containing plot coordinates
plot_locations_HARV <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv")
str(plot_locations_HARV)

# check column names to look for spatial data
names(plot_locations_HARV)

# Easting/Northing contain fields containing spatial information 
head(plot_locations_HARV$easting)
head(plot_locations_HARV$northing)

# Before we convert to a spatial object, we need to know the CRS 
# when we ran line 11, we also have "geodeticDa" and "utmZone"
head(plot_locations_HARV$geodeticDa)
head(plot_locations_HARV$utmZone)

# check crs of HARV points tower
st_crs(point_HARV)

# Create CRS object that we can use to define the CRS of our new sf object when we create it
utm18nCRS <- st_crs(point_HARV)
utm18nCRS

class(utm18nCRS)

## .csv to sf object 
# specify the X Y coordinate values
# specify the crs
plot_locations_sp_HARV <- st_as_sf(plot_locations_HARV, 
                                   coords = c("easting", "northing"),
                                   crs = utm18nCRS)
# Check the new CRS to see if correct
st_crs(plot_locations_sp_HARV)

# Now plot the object 
ggplot() +
  geom_sf(data = plot_locations_sp_HARV) +
  ggtitle("Map of Plot Locations")

# Plot extent adding the aoi boundary 
ggplot() +
  geom_sf(data = aoi_boundary_HARV) +
  geom_sf(data = plot_locations_sp_HARV) +
  ggtitle("AOI Boundary Plot")

## Challenge DIY import and plot additional points 
# 1. Add two phenological plots to our existing map of plots (Harv_2NewPhenPlots.csv)
# 2. they are WGS84 
# 3. plot the new points in the plot locations and add a different symbol for them

newplot_locations_HARV <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv")
str(newplot_locations_HARV)

geogCRS <- st_crs(country_boundary_US)
geogCRS

#ok why is naming so different for this one?
newPlot.Sp.HARV <- st_as_sf(newplot_locations_HARV,
                            coords = c("decimalLon", "decimalLat"),
                            crs = geogCRS)
st_crs(newPlot.Sp.HARV)

ggplot() +
  geom_sf(data = plot_locations_sp_HARV, color = "orange") +
  geom_sf(data = newPlot.Sp.HARV, color = "lightblue") +
  ggtitle("Map of All Plot Locations")

## Exporting an ESRI shapefile
st_write(plot_locations_sp_HARV,
         "data/HARV_PlotLocations.shp", driver = "ESRI Shapefile")


