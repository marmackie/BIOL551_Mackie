###### General Info ######---------------------------------------
# Homework for Week 4
# Using the Chem Data, this script will:
#   1. Remove all NA values from Chem Data
#   2. Use functions separate(), filter(), and pivot_longer() to clean up the data
#   3. Calculate summary statistics such as mean
#   4. Use a subset of the data to generate a grouped bar plot
#   5. Export cleaned data & plot to output folder
#
# Created: 2023-16-02
# Created by: Marisa Mackie
# Edited: 2023-16-02

###### Load Libraries ######-----------------------------------
library(tidyverse)
library(here)

###### Data ######---------------------------------------------
# Loads and looks at our data
ChemData <- read_csv(here("Week_04","data","chemicaldata_maunalua.csv"))

view(ChemData)

###### Analysis ######-----------------------------------------
#------[Cleaning up Data]------
# Creates new dataframe using data from ChemData
ChemData_clean <- ChemData %>% 
  drop_na() %>% # Removes all NA values
  # Below separates Tide_time data into two columns, "Tide" & "Time"
  separate( 
    col = Tide_time,
    into = c("Tide","Time"),
    sep = "_") %>% 
  # Below filters for data collected only during the Day
  filter(Time == "Day") %>% 
  # Below selects for the following columns
  select(Site, Season, Tide, Phosphate, NN) %>% 
  # Below pivots data (cols Phosphate to NN) to long format, and gives the listed col names
  pivot_longer(cols = Phosphate:NN,
               names_to = "Variables",
               values_to = "Measurements") %>% 
  # Below calculates mean of each of the variables in Measurements
  # grouping by season, site, and tide. Excludes NA values.
  group_by(Variables, Season, Site, Tide) %>% 
  summarize(mean_measures = mean(Measurements, na.rm = TRUE)) %>% 
  

# Below exports csv file to output folder
write_csv(here("Week_04","output","Homework_ChemData_clean.csv"))

view(ChemData_clean) # Opens new dataset in viewer

#------[Generate plot]------
# Generates plot using ChemData_clean & maps data to plot variables
ChemData_plot <- ggplot(data = ChemData_clean,
                        aes(x = Variables,
                            y = mean_measures,
                            fill = Tide))+
  
  geom_bar(position = "dodge", stat = "identity")+ # Makes bar plot
  
  # Below subsets plot by Site and Season
  facet_grid(Season~Site)+
  
  # Below creates labels for plot elements
  labs(x = "Chemical Properties",
       y = "Average concentration (umol/L)",
       title = "Average concentration of various Chemical Properties
between Sites during Fall & Spring")+
  
  scale_fill_manual(values = c("darkblue", "seagreen"))+ # specifies fill for High vs Low Tide
  
  # Below specifies color and size for various plot elements
  theme(axis.title = element_text(size = 12, color = "blue"),
        legend.title = element_text(size = 10, color = "blue"),
        panel.background = element_rect(fill = "lightcyan"),
        strip.background.x = element_rect(fill = "tan"),
        strip.background.y = element_rect(fill = "pink"))


ChemData_plot # displays plot

# Below saves plot in output folder
ggsave(here("Week_04","output","Homework_ChemData_plot.png"),
       width = 6, height = 6)