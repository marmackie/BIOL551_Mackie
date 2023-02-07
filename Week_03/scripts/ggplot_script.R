##### Info about Script #####----------------------------------------
# This script will be used to practice plotting data using ggplot2
# 
# created: 2023-02-07
# created by: Marisa Mackie
# edited on: 2023-02-07
#
##### Libraries #####------------------------------------------------
# Be sure to have the "tidyverse" and "palmerpenguins" packages installed
library(tidyverse)
library(palmerpenguins)

##### Data #####-----------------------------------------------------
# Looks at data in penguins
glimpse(penguins)

##### Functions #####------------------------------------------------

#------ mapping & setting ------
# Creates plot using data in penguins
# Note: + adds a layer to our plot; use to add functions together
ggplot(data = penguins,
       
  # maps bill depth in mm as the x-variable
  mapping = aes(x = bill_depth_mm,
                # maps bill length in mm as the y-variable
                y = bill_length_mm,
                # maps a different color to each species
                color = species,
                # maps a different shape to each island
                shape = island,
                # maps a different point size to body mass
                size = body_mass_g,
                # maps different transparencies to flipper length
                alpha = flipper_length_mm
                )) +
  
  # visualizes data as points on plot
  geom_point() +
  
    # adds labels to plot
          # adds title to plot
    labs(title = "Bill depth and length",
          # adds subtitle to plot  
          subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo penguins",
          # labels x and y axes
          x = "Bill depth (mm)", y = "Bill length (mm)",
          # specifies label to color legend
          color = "Species",
          # adds caption with source of data
          caption = "Source: Palmer Staton LTER / palmerpenguins.package",
          # specifies label to shape legend
          shape = "Island",
          # specifies label to size legend
          size = "Body mass (g)",
          # specifies lavel for transparency legend
          alpha = "Flipper length (mm)") +
  
  # changes colors to viridis discrete (color-blind-friendly)
  scale_color_viridis_d()
  
#------ faceting ------
# faceting: creates subplots for subsets of our data
# Creates points plot for data penguins, specifying x, y and colors
ggplot(penguins,
       aes(x = bill_depth_mm,
           y = bill_length_mm,
           color = species)) +
  geom_point() +
  # facets data into a grid (squares)
  # subsets by species (side) and sex (top)
  facet_grid(species~sex) +
  # subsets by species, specifically into 3 columns
  facet_wrap(~ species, ncol = 3) +
  # removes the legend
  guides(color = FALSE)

("Done.")
    