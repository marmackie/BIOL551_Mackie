###### General Info ######----------------------------------------------------
# This script will serve as practice for maps and GIS.
#
# created: 2023-07-03
# created by: Marisa Mackie
# edited on: 2023-07-03

###### Load Libraries ######--------------------------------------------------
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)

###### Data ######------------------------------------------------------------

# Load data on population in California by county
popdata<-read_csv(here("Week_07","data","CApopdata.csv"))

# Load data on number of seastars at different sites
stars<-read_csv(here("Week_07","data","stars.csv"))

###### Analysis ######--------------------------------------------------------

# map_data("location") is the function used to pull out whatever base layer that you want

# get data for the entire world
world<-map_data("world")

# get data for the USA
usa<-map_data("usa")

# get data for italy
italy<-map_data("italy")

# get data for states
states<-map_data("state")

# get data for counties
counties<-map_data("county")

# long = longitude (W of prime meridian is negative)
# lat = latitude
# order = the order ggplot will "connect the dots"
# region & subregion = the area a set of points surrounds
# group = controls whether adjacent points should be connected or not
    # *Note: If you forget to set the group, it won't know when to "lift the pen"
    # and all the points will get connected to each other instead of outlining a specific region!

# make map of the world
ggplot()+
  geom_polygon(data = world, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   # fills color by region (in this case, country)
                   fill = region),
               # outlines each region with black lines
               color = "black")+
  guides(fill = FALSE)+
  
  # makes the "ocean" (background) blue
  theme(panel.background = element_rect(fill = "cornflowerblue"))+
  
  # makes the map 2D (flat)
  coord_map(projection = "mercator",
            xlim = c(-180,180))+
  
  # makes the map more 3D-like (curved)
  coord_map(projection = "sinusoidal",
            xlim = c(-180,180))


# Filters data for California only
CA_data <- states %>% 
  filter(region == "california")

# Makes plot of California
ggplot()+
  geom_polygon(data = CA_data,
               aes(x = long, y = lat, group=group),
               color = "black")+
  coord_map()
  

# Takes population data for California only
CApop_county <- popdata %>% 
  # selects for counties and population, renaming one of the columns as "subregion"
  select("subregion" = County, Population) %>% 
  # joins to two data sets together by county
  inner_join(counties) %>% 
  filter(region == "california")

# creates a plot, polygon plot for map
ggplot()+
  geom_polygon(data = CApop_county, 
               aes(x = long, 
                   y = lat, 
                   group = group,
                   fill = Population),
               # outline color = black
               color = "black")+
  
  # creates points for sites for seastar data
  geom_point(data = stars, 
             aes(x = long, 
                 y = lat,
                 # size of point = number of stars collected
                 size = star_no))+
  
  # projection (default: mercator)
  coord_map()+
  
  # removes gridlines while still letting you change the fill
  theme_void()+
  
  # changes the color scaling by a logarithmic scale
  # makes it so the colors are spread better (outliers don't cause huge disparities in color)
  scale_fill_gradient(trans = "log10")
