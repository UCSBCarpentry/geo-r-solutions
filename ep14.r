# Episode 14
# Extracting From Rasters in R

# Calculate average NDVI

avg_NDVI_HARV <- global(NDVI_HARV_stack, mean)
avg_NDVI_HARV

head(avg_NDVI_HARV)

# change NDVI column name to meanNDVI
names(avg_NDVI_HARV) <- "meanNDVI"
head(avg_NDVI_HARV)

avg_NDVI_HARV$site <- "HARV"

# Repopulate the column with sitename HARV and new column 2011
avg_NDVI_HARV$year <- "2011"
head(avg_NDVI_HARV)

# Extract Julian Dat from row names 
# There is no X in the file names, I don't think this is necessary
julianDays <- gsub("X|_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))
julianDays

avg_NDVI_HARV$julianDay <- julianDays
class(avg_NDVI_HARV$julianDay)

# Convert Julian Day to Date Class
origin <- as.Date("2011-01-01")

avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

avg_NDVI_HARV$Date<- origin + (avg_NDVI_HARV$julianDay - 1)
head(avg_NDVI_HARV$Date)

# date class object
class(avg_NDVI_HARV$Date)


# Challenge: NDVI for San Joaquin Experimental Range
NDVI_path_SJER <- "data/NEON-DS-Landsat-NDVI/SJER/2011/NDVI"

all_NDVI_SJER <- list.files(NDVI_path_SJER,
                            full.names = TRUE,
                            pattern = ".tif$")

NDVI_stack_SJER <- rast(all_NDVI_SJER)
names(NDVI_stack_SJER) <- paste0("X", names(NDVI_stack_SJER))

NDVI_stack_SJER <- NDVI_stack_SJER/10000

# calculate mean values for each day and into a dataframe
avg_NDVI_SJER <- as.data.frame(global(NDVI_stack_SJER, mean))

names(avg_NDVI_SJER) <- "meanNDVI"
avg_NDVI_SJER$site <- "SJER"
avg_NDVI_SJER$year <- "2011"

#Create julian day column
julianDays_SJER <- gsub("X|_SJER_ndvi_crop", "", row.names(avg_NDVI_SJER))
origin <- as.Date("2011-01-01")
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

avg_NDVI_SJER$Date <- origin + (avg_NDVI_SJER$julianDay - 1)

head(avg_NDVI_SJER)

# Plot NDVI Using ggplot
ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")

# Challenge: Plot San Joaquin Experimental Range Data
ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(colour = "SpringGreen4") +
  ggtitle("Landsat Derived NDVI - 2011", subtitle = "NEON SJER Field Site") +
  xlab("Julian Day") + ylab("Mean NDVI")


# Compare NDVI from Two Different Sites in One Plot 

NDVI_HARV_SJER <- rbind(avg_NDVI_HARV, avg_NDVI_SJER)

ggplot(NDVI_HARV_SJER, aes(x = julianDay, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Julian Day") + ylab("Mean NDVI")

# Challenge: Plot NDVI with Date
ggplot(NDVI_HARV_SJER, aes(x = Date, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Date") + ylab("Mean NDVI")


# Removing Outlier Data

# Identify a threshhold value and then remove the values below that threshold
avg_NDVI_HARV_clean <- subset(avg_NDVI_HARV, meanNDVI > 0.1)
avg_NDVI_HARV_clean$meanNDVI < 0.1

ggplot(avg_NDVI_HARV_clean, aes(x = julianDay, y = meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")

# Write NDVI Data to a .csv file
head(avg_NDVI_HARV_clean)

row.names(avg_NDVI_HARV_clean) <- NULL
head(avg_NDVI_HARV_clean)

write.csv(avg_NDVI_HARV_clean, file="meanNDVI_HARV_2011.csv")

# Challenge write to .csv for the NEON SJER field site 
avg_NDVI_SJER_clean <- subset(avg_NDVI_SJER, meanNDVI > 0.1)
row.names(avg_NDVI_SJER_clean) <- NULL
head(avg_NDVI_SJER_clean)

write.csv(avg_NDVI_SJER_clean, file = "meanNDVI_SJER_2011.csv")
