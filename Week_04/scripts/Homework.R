###### General Info ######------------------------------------------------
# Homework Week 4
# For dataset penguins, this script will:
#   1. Calculate mean and variance of body mass by species, island, and sex
#       without any NAs
#   2. Excludes male penguins, calculates log body mass, selects only
#      columns for species, island, sex, log body mass. Then uses these data
#       to make a plot with clean & clear labels. Saves plot in output folder.
#
# created: 2023-02-14
# created by: Marisa Mackie
# collaboration with: Jesse & Avetis
# edited: 2023-02-14

###### Load Libraries ######-------------------------------------------
library(palmerpenguins)
library(tidyverse)
library(here)

###### Data ######-----------------------------------------------------
view(penguins) # Opens penguins in data viewer

###### Analysis ######-------------------------------------------------

#------[Part 1]------
# Creates new dataframe "peng_body_mass" using data from penguins
peng_body_mass <- penguins %>% 
  group_by(species, island, sex) %>% # Groups by species, island, and sex
  drop_na(sex) %>% # Excludes NA values for sex
  # Calculates mean & variance of body mass, excluding NA values
  summarize(mean_body_mass = mean(body_mass_g, na.rm = TRUE),
            var_body_mass = var(body_mass_g, na.rm = TRUE))

view(peng_body_mass) # Opens peng_body_mass in data viewer

#------[Part 2]------
# Creates new dataframe "peng_summary" using data from penguins
peng_summary <- penguins %>% 
  filter(sex != "male") %>% # Excludes male penguins
  mutate(log_body_mass = log(body_mass_g)) %>% # Calculates log body mass and adds new column called log_body_mass
  select(species, island, sex, log_body_mass) # Selects only columns for species, island, sex, log body mass

view(peng_summary) # Opens "peng_summary" in data viewer

# Creates a plot using data from peng_summary
ggplot(data = peng_summary,
       # maps variables on plot to data variables
       mapping = aes(x = species,
                     y = log_body_mass,
                     fill = island)) +

  geom_violin()+ # plot will be a violin plot
  
    # Creates labels for x-axis, y-axis, legend, plot title, and caption
    labs(x = "Species",
         y = "Log Body Mass (g)",
         fill = "Island",
         title = "Female Penguin Body Mass across different Species & Locations",
         caption = "data from `palmer penguins` package")+
  
    scale_fill_manual(values = c("coral", "hotpink", "cyan"))+ # Changes fill colors to the manually-specified colors
  
    # Changes size and color for various plot elements
    theme(axis.title = element_text(size = 13, color = "purple"),
          legend.title = element_text(size = 13, color = "purple"),
          legend.box.background = element_rect(color = "purple"),
          panel.background = element_rect(fill = "lavender"),
          plot.title = element_text(size = 12, color = "black"),
          plot.caption = element_text(size = 8, color = "darkgray"),
          plot.caption.position = "plot",
          plot.title.position = "plot")

# Saves plot in output folder as "peng_plot"
ggsave(here("Week_04","output","peng_plot.png"),
        width = 5, height = 5)