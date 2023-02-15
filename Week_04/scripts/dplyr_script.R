###### General Information ######------------------------
# This script is 
#
# created: 2023-02-14
# created by: Marisa Mackie
# edited on: 2023-02-14

###### Loads Libraries ######----------------------------
library(palmerpenguins)
library(tidyverse)
library(here)

###### Data ######---------------------------------------
# Looks at data
glimpse(penguins)

###### Using dplyr #######-------------------------------

#------[Filter]------
# keeps data only for female penguins
filter(.data = penguins, sex == "female")

# keeps data only for female penguins with body mass greater than 5000g
filter(.data = penguins, sex == "female" & body_mass_g > 5000)

# 2 ways to filter for penguins found in either year 2008 or 2009
filter(.data = penguins, year == 2008 | year == 2009)
filter(.data = penguins, year %in% c(2008, 2009))

# filters for penguins that are NOT from the island Dream
filter(.data = penguins, island != "Dream")

# 3 ways to filter for penguins that are the species Adelie and Gentoo
filter(.data = penguins, species == "Adelie" | species == "Gentoo")
filter(.data = penguins, species %in% c("Adelie", "Gentoo"))
filter(.data = penguins, species != "Chinstrap")

# Note: to save these filtered changes, need to assign a new object 
# to hold that data

#------[Mutate]------
# Adds a new column for converting body mass g to kg, adds it to new object data2
data2 <- mutate(.data = penguins, body_mass_kg = body_mass_g/1000)
view(data2)

#

# If the year is greater than 2008, add it to new column called "After 2008"
# If the year is 2008 or less, add it to new column called "Before 2008"
data2 <- mutate(.data = penguins, 
                after_2008 = ifelse(year > 2008, "After 2008", "Before 2008"))
view(data2)

# Adds new column to add values for flipper length and body mass together
data2 <- mutate(.data = penguins,
                flipper_body_sum = flipper_length_mm + body_mass_g,
                # If body mass is greater than 4000, add it to new column called "big"
                # Otherwise, add to new column called "small"
                size = ifelse(body_mass_g > 4000, "big", "small"))
view(data2)

# example of using a pipe %>%
# uses penguins dataframe
penguins %>%
  # filters for female penguins
  filter(sex == "female") %>%
  # adds column that takes the log of body mass
  mutate(log_mass = log(body_mass_g))

#------[Select]------
# Selects data from the listed columns
penguins %>%
  select(species, island, sex)

# Selects data from the listed columns
# Renames "species" column to "Species"
penguins %>%
  select(Species = species, island, sex)

#------[Summarize]------
# Calculates mean & minimum of flipper length (excluding NAs) and summarizes
# into new dataframe data2
data2 <- penguins %>%
  summarize(mean_flipper = mean(flipper_length_mm, na.rm = TRUE),
            min_flipper = min(flipper_length_mm, na.rm = TRUE))
view(data2)

# Summarizes mean flipper length (excluding NAs), grouping by island and sex
data2 <- penguins %>%
  group_by(island, sex) %>%
  summarize(mean_flipper = mean(flipper_length_mm, na.rm = TRUE))
view(data2)

# drops NA values for specified column
data2 <- penguins %>%
  drop_na(sex)
view(data2)
