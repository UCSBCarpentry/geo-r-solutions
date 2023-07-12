# ep 10
# Converting from .csv to a vector layer 
# How to import spatial points stored onto a .csv into an R/sf spatial object 

library(terra)
library(sf)

#Import a new csv containing plot coordinates
HARV_plot_locations <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv")
str(HARV_plot_locations)

# Kristi note: make naming consistent, "HARV" should come first so we know the locale

# check column names to look for spatial data
names(HARV_plot_locations)

# Easting/Northing contain fields containing spatial information 
head(HARV_plot_locations$easting)
head(HARV_plot_locations$northing)

# Before we convert to a spatial object, we need to know the CRS 
# when we ran line 11, we also have "geodeticDa" and "utmZone"
head(HARV_plot_locations$geodeticDa)
head(HARV_plot_locations$utmZone)

# check crs of HARV points tower
st_crs(HARV_points)

# Create CRS object that we can use to define the CRS of our new sf object when we create it
utm18nCRS <- st_crs(HARV_points)
utm18nCRS

class(utm18nCRS)

## .csv to sf object 
# specify the X Y coordinate values
# specify the crs 

HARV_plot_locations_sp <- st_as_sf(HARV_plot_locations, 
                                   coords = c("easting", "northing"),
                                   crs = utm18nCRS)
# Check the new CRS to see if correct
st_crs(HARV_plot_locations_sp)

# Now plot the object 
ggplot() +
  geom_sf(data = HARV_plot_locations_sp) +
  ggtitle("Map of Plot Locations")

# Plot extent adding the aoi boundary 
ggplot() +
  geom_sf(data = aoi_boundary_HARV) +
  geom_sf(data = HARV_plot_locations_sp) +
  ggtitle("AOI Boundary Plot")

## Challenge DIY import and plot additional points 
# 1. Add two phenological plots to our existing map of plots (Harv_2NewPhenPlots.csv)
# 2. they are WGS84 
# 3. plot the new points in the plot locations and add a different symbol for them

newplot_loc_HARV <-
  read.csv("data/NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv")
str(newplot_loc_HARV)

geogCRS <- st_crs(country_boundary_US)
geogCRS

Phenplot_sp_HARV <- st_as_sf(newplot_loc_HARV,
                            coords = c("decimalLon", "decimalLat"),
                            crs = geogCRS)
st_crs(Phenplot_sp_HARV)

ggplot() +
  geom_sf(data = HARV_plot_locations_sp, color = "orange") +
  geom_sf(data = Phenplot_sp_HARV, color = "lightblue") +
  ggtitle("Map of All Plot Locations")

## Exporting an ESRI shapefile
st_write(HARV_plot_locations_sp,
         "data/HARV_PlotLocations.shp", driver = "ESRI Shapefile")


