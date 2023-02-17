####### General Info ######--------------------------------------
# In this script, we will practice tidyr with biogeochemistry data from Hawaii
#
# Created: 2023-02-16
# Created by: Marisa Mackie
# edited: 2023-02-16

###### Load Libraries ######-------------------------------------
library(tidyverse)
library(here)

###### Data ######-----------------------------------------------
# Loads and looks at our data
ChemData <- read_csv(here("Week_04","data","chemicaldata_maunalua.csv"))

view(ChemData)

###### Analysis ######-------------------------------------------
ChemData_clean <- ChemData %>% 
  filter(complete.cases(.)) %>% # removes incomplete cases (NA values)
  separate(
    col = Tide_time, # chooses column to separate
    into = c("Tide","time"), # separates into columns called "Tide" & "time"
    sep = "_", # separates by _
    remove = FALSE) # keeps original column
  unite(
    col = "Site_Zone", # specifies column to unite into
    c(Site, Zone), # chooses data to unite together
    sep = ".", # separates by .
    remove = FALSE) # keeps original columns

view(ChemData_clean)

# pivots our wide data to long data
ChemData_long <- ChemData_clean %>% 
  pivot_longer(cols = Temp_in:percent_sgd, # specifies columns from Temp_in to percent_sgd
               names_to = "Variables", # "Variables" will hold all column names
               values_to = "Values") # "Values" will hold all the values

view(ChemData_long)

ChemData_long %>% 
  group_by(Variables, Site) %>% # group by "Variables" & "Site"
  summarise(Param_means = mean(Values, na.rm = TRUE), # get mean
            Param_vars = var(Values, na.rm = TRUE)) # get variance

# Note: DO NOT name variables as function names, or else R will not understand
# e.g., use param_means = mean(), instead of mean = mean()

# Challenge: calculate mean, variance, and standard deviation for all variables,
# by site, zone, and tide

ChemData_long %>% 
  group_by(Variables, Site) %>% 
  summarize(Param_means = mean(Values, na.rm = TRUE),
            Param_vars = var(Values, na.rm = TRUE),
            Param_sd = sd(Values, na.rm = TRUE))

# Generates box plot of our data
ChemData_long %>%
  ggplot(aes(x = Site, y = Values))+ # maps x and y variables
  geom_boxplot()+ # specifies box plot
  facet_wrap(~Variables, # 
             scales = "free") # frees axes from a fixed range

# Pivots long data back to wide
ChemData_wide <- ChemData_long %>% 
  pivot_wider(names_from = Variables,
              values_from = Values)

view(ChemData_wide)
#---[All together]--------------------------------------------
ChemData_clean <- ChemData %>% 
  drop_na() %>% 
  separate(col = Tide_time,
           into = c("Tide","Time"),
           sep = "_",
           remove = FALSE) %>% 
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") %>% 
  group_by(Variables, Site, Time) %>%
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>% 
  pivot_wider(names_from = Variables,
              values_from = mean_vals) %>% 
  write_csv(here("Week_04","output","ChemData_summary.csv"))

view(ChemData_clean)