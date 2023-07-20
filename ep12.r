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
