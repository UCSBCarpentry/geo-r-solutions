# re-writing for the terra-instance of the lesson

# library(raster)
# library(rgdal)
library(ggplot2)
library(dplyr)
library(terra)

# lesson text says we'll use sf in this episode
# but I don't think so

getwd()
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

HARV_DSM_info <- capture.output(
  describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
)


HARV_DSM <- 
  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

HARV_DSM

summary(HARV_DSM)

summary(values(HARV_DSM))

# or the tidy way
values(HARV_DSM) %>% summary()

# as usual, ggplot wants dataframes
HARV_DSM_df <- as.data.frame(HARV_DSM, xy = TRUE)

str(HARV_DSM_df)

# change the name of the column to better reflect what it is:
# this isn't in the lesson
names(HARV_DSM_df)[names(HARV_DSM_df) == 'HARV_dsmCrop'] <- 'Elevation'


str(HARV_DSM_df)

ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = Elevation)) +
  scale_fill_viridis_c() +
  coord_quickmap()

crs(HARV_DSM)

# calculating maxes and mins
# minmax() doesn't work anymore. maybe it's from raster
# minmax(HARV_DSM)
# values() forces it to look at all the values:

min(values(HARV_DSM))
max(values(HARV_DSM))




# we skipped nlyr

# deal with NA's
# I think this ggplot should go after any(is.na) and summary()
# it doesn't actually show any NA's
ggplot() +
  geom_raster(data = HARV_DSM_df , aes(x = x, y = y, fill = Elevation)) +
  scale_fill_viridis_c(na.value = 'deeppink') +
  coord_quickmap()


#check if there are actually any NA's
#A few ways: 

# this one doesn't show any.
any(is.na(HARV_DSM_df$Elevation))

# this one shows them explicitly!
HARV_DSM_info

# challenge:
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# it doesn't seem like sources works
#sources(HARV_DSM)
#describe(sources(HARV_DSM))



# this shows our current raster doesn't have any.
summary(HARV_DSM)

### To get a similar image in the lesson example
# Load image into dataframe
HARV_DTM_df <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif") %>% 
  as.data.frame(xy = TRUE)

ggplot() +
  geom_raster(data = HARV_DTM_df , aes(x = x, y = y, fill = HARV_DTMhill_WGS84)) +
  scale_fill_viridis_c(na.value = 'deeppink') +
  coord_quickmap()


# dealing with bad values
# lesson shows a figure that it doesn't make.
# (the map with the pink pixels over 400m)
# here's the code:
# The line below is throwing me off: 
DSM_highvals <- classify(HARV_DSM, rcl = c(0, 400, NA, 420, 1L), include.lowest = TRUE)

# ^^^^^^^^
# that's not very elegant at all. There must be a way to get only > 400 and overlay it.
# originally DSM_highvals <- reclassify(DSM_HARV, rcl=c(0,400,Na_Integer_,420,1L), include.lowest =TRUE)


############################
# it doesn't seem like anything past here is actually in the lesson

### here the elevation isn't being replaced correctly and I'm not sure where to fix
DSM_highvals <- as.data.frame(DSM_highvals, xy = TRUE)
str(DSM_highvals)


# change that name again
names(DSM_highvals)[names(DSM_highvals) == 'HARV_dsmCrop'] <- 'Elevation'
str(DSM_highvals)

ggplot() +
  geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = Elevation)) + 
  scale_fill_viridis_c() + 
  # use reclassified raster data as an annotation
  annotate(geom = 'raster', x = DSM_highvals$x, y = DSM_highvals$y, fill = scales::colour_ramp('deeppink')(DSM_highvals$Elevation)) +
  ggtitle("Elevation Data", subtitle = "Highlighting values > 400m") +
  coord_quickmap()
### Error in reclass for sure
##  Unequal parameter lengths: x, y, are fine, fill is empty? 
##  now its all pink
## I think reclass messed up

# ^^^^^^
# oddly the error message from this says there's a ton of NA's.
# the reclass must have created a bunch.
# lesson 2 solves this question by creating custom bins.

summary(DSM_highvals)

ggplot() +
  geom_histogram(data = HARV_DSM_df, aes(Elevation))

# skipped making more bins.

# Challenge
# getting info about another raster
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif")
### GDALinfor replaced with "describe" 