###### General Info ######----------------------------------------------------
# This script will serve as practice for ggmaps using API key
#
# created: 2023-09-03
# created by: Marisa Mackie
# edited on: 2023-09-03

###### Load Libraries ######---------------------------------------------------
library(ggmap)
library(ggsn)
library(tidyverse)
library(here)

# Note: DO NOT PUSH YOUR KEY TO GITHUB
register_google(key = "AIzaSyA-aGCguFlU1fCnHykydTmsLj3awGoCGe4", write = TRUE)

###### Data ######-------------------------------------------------------------
ChemData <- read_csv(here("Week_07", "data", "chemicaldata_maunalua.csv"))

###### Analysis ######---------------------------------------------------------

# get map of Oahu from Google Maps
Oahu <- get_map("Oahu")

# Make data frame of longitude & latitude coordinates
WP <- data.frame(lon = -157.7621, lat = 21.27427)

# Get base layer map
Map1 <- get_map(WP)

# Plot map
ggmap(Map1)

# Zooms in on a place
# Zoom value = int between 3 - 20
# 3 = continent level, 20 = single building level
Map1 <- get_map(WP, zoom = 17)
ggmap(Map1)

# Changes map type to satellite
Map1 <- get_map(WP, zoom = 17, maptype = "satellite")
ggmap(Map1)

# Changes map type to watercolor
Map1 <- get_map(WP, zoom = 17, maptype = "watercolor")
ggmap(Map1)

# Plot data on top of our map layer
Map1<-get_map(WP,zoom = 17, maptype = "satellite") 
ggmap(Map1)+
  geom_point(data = ChemData,
             aes(x = Long, y = Lat, color = Salinity),
             size = 4) +
  scale_color_viridis_c()+
  # Adds a scale bar to plot
  scalebar( x.min = -157.766, x.max = -157.758,
            y.min = 21.2715, y.max = 21.2785,
            dist = 250, dist_unit = "m", model = "WGS84", 
            transform = TRUE, st.color = "white",
            box.fill = c("yellow", "white"))

# If you don't know the coordinates, use geocode() to find out
geocode("the white house")
geocode("California State University, Northridge")
