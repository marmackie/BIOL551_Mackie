##### Information about Script #####---------------------
# BIOL 551/L Week 2
# Learning how to import data and how to write a transparent script
# Created by: Marisa Mackie
# Created on: 2023-02-02
# Updated on: 2023-02-02

##### Load Libraries #####-------------------------------

library(here)
library(tidyverse)

##### Read Data #####------------------------------------

# Starts path at Week_02 folder and reads weight data
# Assigns weight data to object weight_data
weight_data <- read_csv(here("Week_02", "data", "weightdata.csv"))

##### Data Analysis #####-------------------------------------

# Looks at the first 6 lines of weight_data
head(weight_data)

# Looks at last 6 lines of weight_data
tail(weight_data)

# Opens weight_data in new window
view(weight_data)

# Provides information about weight_data, including data type
glimpse(weight_data)

# Prints "Done."
("Done.")