# Episode 12
# Raster Time Series Data

library(terra)
library(tidyr)
library(ggplot2)
library(scales)

#create a list of raster files we want to stack

NDVI_HARV_path <- "data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI"

all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")
#check the filenames
all_NDVI_HARV

#create a stack of raster using the rast() function
NDVI_HARV_stack <- rast(all_NDVI_HARV)

crs(NDVI_HARV_stack, proj = TRUE)

## Challenge: Raster Metadata
# 1. what are x and y resolution of the data
# 2. What units are ^ resolutin in?

ext(NDVI_HARV_stack)
yres(NDVI_HARV_stack)
xres(NDVI_HARV_stack)

## Plotting time series data

#using the gather function from tidyr
NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy= TRUE) %>% 
  gather(variable, value, -(x:y))

#use ggplot and use facet wrapping to create a multipaneled plot
ggplot()+
  geom_raster(data = NDVI_HARV_stack_df, aes(x = x,y = y, fill = value))+
  facet_wrap(~ variable)

## Scale factors

#metadata includes information on the scale factor:10000
#use some raster math to apply it
NDVI_HARV_stack <- NDVI_HARV_stack/10000

#recreate plot from previous exercise with new scale
NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>% 
  gather(variable,value, -(x:y))

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable)

## View distribution of Raster values

#use histograms to explore the distribution of NDVI values
ggplot(NDVI_HARV_stack_df)+
  geom_histogram(aes(value))+
  facet_wrap(~variable)

#Explore Unusual Data Patterns
har_met_daily <-
  read.csv("data/NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-06-daily-m.csv")
str(har_met_daily)

#use as.Date() to convert characters to be treated as dates
har_met_daily$date <- as.Date(har_met_daily$date, format = "%Y-%m-%d")

#filter out only the 2011 data
yr_11_daily_avg <- har_met_daily %>% 
  filter(between(date,as.Date('2011-01-01'), as.Date('2011-12-31')))

#plot the air temperature by julian day
ggplot() +
  geom_point(data = yr_11_daily_avg, aes(jd, airt)) +
  ggtitle("Daily Mean Air Temperature",
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Day 2011") +
  ylab("Mean Air Temperature (C)")


## Challenge
# plot the RGB images for Julian days 277 and 293
# compare plots for Julian days 133 and 197
# whats throwing off the NDVI?

RGB_277 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/277_HARV_landRGB.tif")

# NOTE: Fix the bands' names so they don't start with a number!
names(RGB_277) <- paste0("X", names(RGB_277))

RGB_277

# divide by 255 to keep color intensity
RGB_277 <- RGB_277/255

# convert to dataframe
RGB_277_df <- as.data.frame(RGB_277, xy = TRUE)

# create RGB colors
RGB_277_df$rgb <- 
  with(RGB_277_df, rgb(X277_HARV_landRGB_1, X277_HARV_landRGB_2, 
                       X277_HARV_landRGB_3, 1))
# plot julian day 277:
ggplot() +
  geom_raster(data=RGB_277_df, aes(x, y), fill=RGB_277_df$rgb) + 
  ggtitle("Julian day 277") 

# Now do the same for JD 293

#load data
RGB_293 <- rast("data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/293_HARV_landRGB.tif")
names(RGB_293) <- paste0("X", names(RGB_293))

#set channel
RGB_293 <- RGB_293/255

#make dataframe
RGB_293_df <- as.data.frame(RGB_293, xy = TRUE)

#make RGB channels
RGB_293_df$rgb <- 
  with(RGB_293_df, rgb(X293_HARV_landRGB_1, X293_HARV_landRGB_2, 
                       X293_HARV_landRGB_3,1))
#plot JD 293
ggplot() +
  geom_raster(data = RGB_293_df, aes(x, y), fill = RGB_293_df$rgb) +
  ggtitle("Julian day 293")


