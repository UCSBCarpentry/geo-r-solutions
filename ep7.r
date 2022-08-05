# ep 3

# make sure we have the needed libraries
library(sf)
library(raster)
library(ggplot2)

# this shows us the attribute table
# there's only one point
View(HARV_points)

# outputting only the variable names
# shows you a count of the objects
# and some other metadata
# and a sort of 'HEAD'
HARV_points
HARV_lines

# we can count the attributes
ncol(HARV_lines)

# we can view the attribute names
names(HARV_lines)
names(HARV_points)

# our old friend helps too:
head(HARV_lines)

# challenge is here
HARV_points$Ownership

# call out a whole column / attribute:
HARV_lines$TYPE

# only the unique values
levels(HARV_lines$TYPE)

# all this stuff works with the tidyverse
# so you can use pipes
HARV_footpath <- HARV_lines %>% 
  filter(TYPE == "footpath")

nrow(HARV_footpath)
head(HARV_footpath)

# now the exciting part, let's map it
ggplot() + 
  geom_sf(data = HARV_footpath) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths") + 
  coord_sf()


ggplot() + 
  geom_sf(data = HARV_footpath, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Footpath ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Footpaths") + 
  coord_sf()

# challenge 1
boardwalk_HARV <- HARV_lines %>% 
  filter(TYPE == "boardwalk")

# there's 1 row
nrow(boardwalk_HARV)

ggplot() + 
  geom_sf(data = boardwalk_HARV, size = 1.5) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Boardwalks") + 
  coord_sf()

# challenge 2
stoneWall_HARV <- HARV_lines %>% 
  filter(TYPE == "stone wall")

nrow(stoneWall_HARV)

ggplot() +
  geom_sf(data = stoneWall_HARV, aes(color = factor(OBJECTID)), size = 1.5) +
  labs(color = 'Wall ID') +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Stonewalls") + 
  coord_sf()


levels(HARV_lines$TYPE)
