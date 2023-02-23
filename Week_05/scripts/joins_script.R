###### General Info ######--------------------------------------------
# In this script we will be using site characteristics data to practice
# using joins.
#
# created: 2023-02-21
# created by: Marisa Mackie
# edited: 2023-02-21

###### Load Libraries ######------------------------------------------
library(tidyverse)
library(here)

###### Data ######----------------------------------------------------
EnviroData <- read_csv(here("Week_05", "data", "site.characteristics.data.csv"))

TPCData<-read_csv(here("Week_05","data","Topt_data.csv"))

view(EnviroData)
view(TPCData)

###### Analysis ######------------------------------------------------

#-----[Enviro & TPC Data]-----
EnviroData_wide <- EnviroData %>% 
  # Pivots EnviroData into wide format, so that both datasets are wide
  pivot_wider(names_from = parameter.measured,
              values_from = values) %>% 
  # Arranges the dataframe by site
  arrange(site.letter)

view(EnviroData_wide)

# Joins TPC & Enviro data together
  FullData_left<- left_join(TPCData, EnviroData_wide)
  
  FullData_left<- left_join(TPCData, EnviroData_wide) %>%
    # Puts all the numeric data after the character data
    relocate(where(is.numeric), .after = where(is.character)) %>% 
    
  #
  FullData_summary <- FullData_left %>% 
    pivot_longer(cols = E:substrate.cover,
                 names_to = "variables",
                 values_to = "values") %>%
    group_by(site.letter, variables) %>% 
    summarize(mean_vals = mean(values, na.rm = TRUE),
              var_vals = var(values, na.rm = TRUE))
  
  view(FullData_summary)
  
#-----[Tibbles]-----
# Creates two tibbles with made-up data
T1 <- tibble(Site.ID = c("A", "B", "C", "D"), 
               Temp = c(14.1, 16.7, 15.3, 12.8))
T2 <- tibble(Site.ID = c("A", "B", "D", "E"), 
               pH = c(7.3, 7.8, 8.1, 7.9))

view(T1)
view(T2)

# left_join
# Joins data into T1 (T1 is on the left, retains the left)
left_join(T1,T2)

# right_join
# Joins data into T2 (T2 is on the right, retains the right)
right_join(T1,T2)

# inner_join
# Only keeps data that is complete in both sets (no NAs)
inner_join(T1, T2)

# full_join
# Keeps all data
full_join(T1, T2)

# semi_join
# Only keeps data where there are corresponding values in the 2nd dataset
# (Uses cols from 1st dataset)
semi_join(T1, T2)

# anti_join
# Only keeps data that does not correspond to anything in the 2nd data set
# (Useful for finding missing data between datasets)
anti_join(T1, T2)

