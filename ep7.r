# ep 7

# make sure we have the needed libraries
library(sf)
# library(raster)
library(ggplot2)

# this shows us the attribute table
# there's only one point
View(point_HARV)

# outputting only the variable names
# shows you a count of the objects
# and some other metadata
# and a sort of 'HEAD'
point_HARV
lines_HARV

# we can count the attributes
ncol(lines_HARV)

# we can view the attribute names
names(lines_HARV)
names(point_HARV)

# our old friend helps too:
head(lines_HARV)

# challenge is here

#find number of attributes
ncol(point_HARV)

ncol(aoi_boundary_HARV)
# call out a whole column / attribute:
point_HARV$Ownership

names(point_HARV)
# only the unique values
# but this doesn't give what you expect. 
# see below
# the original fix was around line 100
#levels(HARV_lines$TYPE)

lines_HARV$TYPE

#To see only unique values 
unique(lines_HARV$TYPE)


# must convert that plain text to a factor
#HARV_lines$TYPE <- factor(HARV_lines$TYPE)

##Subset Features

# all this stuff works with the tidyverse
# so you can use pipes
footpath_HARV <- lines_HARV %>% 
  filter(TYPE == "footpath")
nrow(footpath_HARV)

nrow(footpath_HARV)
head(footpath_HARV)

# now the exciting part, let's map it
ggplot() + 
  geom_sf(data = footpath_HARV) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths") + 
  coord_sf()


ggplot() + 
  geom_sf(data = footpath_HARV, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Footpath ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths") + 
  coord_sf()

# challenge 1
boardwalk_HARV <- lines_HARV %>% 
  filter(TYPE == "boardwalk")

# there's 1 row
nrow(boardwalk_HARV)

ggplot() + 
  geom_sf(data = boardwalk_HARV, size = 1.5) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Boardwalks") + 
  coord_sf()

# challenge 2
stoneWall_HARV <- lines_HARV %>% 
  filter(TYPE == "stone wall")
nrow(stoneWall_HARV)


ggplot() +
  geom_sf(data = stoneWall_HARV, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Wall ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Stonewalls") + 
  coord_sf()


# this just moves on in the lesson
# but if we want to see unique values,
# we have to get that column to be a factor
lines_HARV$TYPE <- factor(lines_HARV$TYPE)
# now we can see that we need 4 colors

unique(lines_HARV$TYPE)

road_colors <- c("blue", "green", "navy", "purple")

ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE)) + 
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads & Trails") + 
  coord_sf()

# use different line widths
line_widths <- c(1, 2, 3, 4)
ggplot() +
  geom_sf(data = lines_HARV, aes(color = TYPE, size = TYPE)) + 
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  scale_size_manual(values = line_widths) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads & Trails - Line width varies") + 
  coord_sf()

##Challenge: Plot line width by attribute
# they come out in the order they are stored,
# so you can assign in that order
unique(lines_HARV$TYPE)
line_width <- c(1, 3, 2, 6)

ggplot() +
  geom_sf(data = lines_HARV, aes(size = TYPE)) +
  scale_size_manual(values = line_width) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads & Trails - Line width varies") + 
  coord_sf()

# work on that legend
ggplot() + 
  geom_sf(data = lines_HARV, aes(color = TYPE), size = 1.5) +
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') + 
  ggtitle("NEON Harvard Forest Field Site", 
          subtitle = "Roads & Trails - Default Legend") + 
  coord_sf()

# change legend text and draw a box around it
ggplot() + 
  geom_sf(data = lines_HARV, aes(color = TYPE), size = 1.5) +
  scale_color_manual(values = road_colors) + 
  labs(color = 'Road Type') +
  theme(legend.text = element_text(size = 14), 
        legend.box.background = element_rect(size = 1)) + 
  ggtitle("NEON Harvard Forest Field Site", 
          subtitle = "Roads & Trails - Modified Legend") +
  coord_sf()

# make the colors less obnoxious
new_colors <- c("springgreen", "blue", "magenta", "orange")

ggplot() + 
  geom_sf(data = lines_HARV, aes(color = TYPE), size = 1.5) + 
  scale_color_manual(values = new_colors) +
  labs(color = 'Road Type') +
  theme(legend.text = element_text(size = 14), 
        legend.box.background = element_rect(size = 1)) + 
  ggtitle("NEON Harvard Forest Field Site", 
          subtitle = "Roads & Trails - Pretty Colors") +
  coord_sf()


# bicycle challenge
lines_HARV$BicyclesHo <- as.factor(lines_HARV$BicyclesHo)
class(lines_HARV$BicyclesHo)

# same iss ue as roadtype
levels(lines_HARV$BicyclesHo)

# remove missing values
lines_removeNA <- lines_HARV[!is.na(lines_HARV$BicyclesHo),]

# First, create a data frame with only those roads where bicycles and horses are allowed
lines_showHarv <- 
  lines_removeNA %>% 
  filter(BicyclesHo == "Bicycles and Horses Allowed")

# Next, visualise using ggplot
ggplot() + 
  geom_sf(data = lines_HARV) + 
  geom_sf(data = lines_showHarv, aes(color = BicyclesHo), size = 2) + 
  scale_color_manual(values = "magenta") +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads Where Bikes and Horses Are Allowed") + 
  coord_sf()


## all new data
## skip last challenge for time
## even skipping last challenge, there's a lot in this episode 