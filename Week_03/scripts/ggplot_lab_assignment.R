###### General Information ######------------------------------
# This script is for the group lab assignment to create a good plot
# using data from palmerpenguins
#
# created: 2023-02-09
# created by: Marisa Mackie
# collaboration with: Jesse & Avetis
# edited on: 2023-02-13

###### Loads Libraries ######----------------------------------------
library(palmerpenguins)
library(tidyverse)
library(here)

###### Data ######---------------------------------------------
# Looks at penguins dataset
glimpse(penguins)

###### Analysis ######-----------------------------------------
# creates new dataframe penguin_summary
penguin_summary <- penguins %>% 
  # omits NA values
  na.omit() %>%
  # groups penguins data by species and sex in penguin_summary
  group_by(species, sex) %>%
  # takes average of flipper length
  summarize(flipper_mean= mean(flipper_length_mm))

# creates plot called plot1 using data from penguin_summary
plot1 <- ggplot(data = penguin_summary,
      # color of bars mapped to sex (male/female)
       mapping = aes(fill = sex,
           # maps y-variable to average flipper length
           y = flipper_mean,
           # maps x-variable to species
           x = species,))+
  # sets plot to bar plot
  geom_bar(position = "dodge", 
           stat = "identity") +
  # labels x & y axes, legend, and plot title
  labs(x = "Species",
        y = "Flipper length (mm)",
        fill = "Sex",
        title = "Flipper Length of Male vs Female Penguins")+
  
  # Makes axis titles bigger and blue
  theme(axis.title = element_text(size = 15, color = "blue"))

# shows plot1
plot1

# saves plot as an image in output folder
ggsave(here("Week_03","output","ggplot_penguin.png"),
       width = 7, height = 6)