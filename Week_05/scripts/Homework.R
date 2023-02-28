###### General Info ######-----------------------------------------------------
# This script will:
#     1. take Conductivity Data & Depth data
#     2. fix the dates & select for data appropriately
#     3. join the datasets together
#     4. takes averages of salinity, temperature, and depth per minute
#     5. generate a plot showing the relationship between the averaged variables
#     6. save plot to output folder
# 
# Created: 2023-02-23
# Created by: Marisa Mackie
# Edited: 2023-02-28

###### Load Libraries ######---------------------------------------------------
library(tidyverse)
library(here)
library(lubridate)

###### Data ######-------------------------------------------------------------
# Loads & opens Conductivity data
CondData <- read_csv(here("Week_05","data","CondData.csv"))
view(CondData)

# Loads & opens Depth data
DepthData <- read_csv(here("Week_05", "data","DepthData.csv"))
view(DepthData)

###### Analysis ######---------------------------------------------------------

#-----[Data Cleanup]-----

# Adjusts dates in CondData to proper date format & rounds it to match DepthData
CondData <- CondData %>% 
  
  # Converts MM-DD-YYYY to YYYY-MM-DD dates in new date column, replacing old date column
  mutate(date = mdy_hms(date)) %>% 
  
  # Rounds dates to nearest 10 seconds
  mutate(date = round_date(date, unit = "10 seconds"))

view(CondData) # Looks at CondData

# Joins conductivity data & depth data such that NAs are not included, in new tibble Cond_Depth_Data
Cond_Depth_Data <- inner_join(CondData, DepthData)

view(Cond_Depth_Data) # Looks at new tibble

# Creates new column in tibble extracting hour & minute
Cond_Depth_Data <- Cond_Depth_Data %>% 
  
  # Extracts hour and minute into separate cols
  mutate(hour = hour(date),minute = minute(date)) %>% 
  
  # Unites hour and minute columns into one hour_min col
  unite(col = "hour_min",
        c(hour,minute),
        sep = "_",
        remove = FALSE) %>% 
  
  # Selects only for listed cols
  select(hour_min, Depth, Temperature, Salinity) %>% 
  
  # Calculates average of all parameters, grouping by hour_min
  group_by(hour_min) %>% 
  summarize(means_Depth = mean(Depth, na.rm = TRUE),
            means_Temp = mean(Temperature, na.rm = TRUE),
            means_Sal = mean(Salinity, na.rm = TRUE)) 

#-----[Plot]-----

# Creates plot & specifies x, y, and color variables
CondDepth_plot <- ggplot(data = Cond_Depth_Data,
  mapping = aes(x = means_Temp,
                y = means_Sal,
                color = means_Depth))+
  
  # Specifies scatterplot with jitter
  geom_jitter(width = 5)+
  
  # Labels axes and titles appropriately
  labs(x = "Average Temperature",
       y = "Average Salinity",
       color = "Average Depth",
       title = "Average Salinity vs Temperature at different Depths")+

  # Specifies color gradient for points
  scale_color_gradient2()+
  
# Specifies size and color of plot elements
  theme(axis.title = element_text(size = 15),
      legend.title = element_text(size = 15),
      panel.background = element_rect(fill = "azure2"),
      plot.title = element_text(size = 20))

# View plot
CondDepth_plot

# Saves plot to output folder & specifies dimensions
ggsave(here("Week_05","output","CondDepth_plot.png"),
       width = 11, height = 7)