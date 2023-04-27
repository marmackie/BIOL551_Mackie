#### General Info ####------------------------------------
#
# Iterative coding
#
# created: 2023-25-04
# created by: Marisa Mackie

#### Load Libraries ####----------------------------------
library(tidyverse)
library(here)

#### Data ####--------------------------------------------

#### For Loops ####----------------------------------------
# Command looks like this
# for (index in sequence){
#   command you want to repeat}

# example:
years <- c(2015:2021)

for (i in years){ # set up the for loop where i is the index
  print(paste("The year is", i)) # loop over i
}

# note: by default, it will iterate by 1

#-----------IMPORTANT----------
# To save a new vector with all your information from the for-loop,
# you MUST pre-allocate space for it
# i.e. create an empty dataframe, vector, matrix, etc. for R to store the output
#------------------------------

# Preallocate space for the for loop
# empty matrix convert to dataframe
year_data <- data.frame(matrix(ncol = 2, nrow = length(years)))

#add column names
colnames(year_data) <- c("year","year_name")

# For loop:
# iterates through i, from the 1st item to the length of years
for (i in 1:length(years)){
  # calls for i'th thing in the column "year_name" in dataframe year_data
  # then pastes "the year is" in front of whichever i'th thing in years
  year_data$year_name[i] <- paste("The year is",years[i])
  year_data$year[i]
}

# Using for loops to read in multiple .csv files--------
testdata <- read_csv(here("Week_12","data","cond_data","011521_CT316_1pcal.csv"))

glimpse(testdata)

# point to the location on the computer of the folder
CondPath<-here("Week_12", "data", "cond_data")
# list all the files in that path with a specific pattern
# In this case we are looking for everything that has a .csv in the filename
# you can use regex to be more specific if you are looking for certain patterns in filenames
files <- dir(path = CondPath,pattern = ".csv")
files

# Example----
# let's calculate mean temp & salinity in each file & save it
#pre-allocate space - makes empty dataframe rows = num of files, cols = 3
cond_data <- tibble(nrows = length(files), ncols = 3)

# give the dataframe column names
colnames(cond_data)<-c("filename","mean_temp", "mean_sal")
cond_data

## first write basic code to calculate mean, then build for loop around it
raw_data<-read_csv(paste0(CondPath,"/",files[1])) # test by reading in the first file and see if it works
head(raw_data)

# calculate mean temperature for whole file, dropping NAs
mean_temp<-mean(raw_data$Temperature, na.rm = TRUE)
mean_temp

## now create for loop

# pre-allocate space - makes empty dataframe rows = num of files, cols = 3
cond_data<-data.frame(matrix(nrow = length(files), ncol = 3))

# give the dataframe column names
colnames(cond_data)<-c("filename","mean_temp", "mean_sal")
cond_data

for (i in 1:length(files)){ # loop over 1 to number of files
  # read in raw data 
  raw_data<-read_csv(paste0(CondPath,"/",files[i]))
  #
  cond_data$filename[i]<-files[i]
  # calculates mean of Temperature in raw_data for every file in cond_data
  cond_data$mean_temp[i]<-mean(raw_data$Temperature, na.rm =TRUE)
  # calculates mean of Salinity in raw_data for every file in cond_data
  cond_data$mean_sal[i]<-mean(raw_data$Salinity, na.rm =TRUE)
}

cond_data


#### Purrr - Tidyverse for loops ####---------------------------
# purpose:
#  family of map() functions which allow you to replace many for loops with code that is both more succinct and easier to read. 

### map functions----
# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.
# map_df() makes a dataframe

# Note: you do not need to pre-allocate space for map functions

### Example----
1:10 # vector 1 to 10

1:10 %>% # we will do this 10 times
  map(rnorm, n =15) # calculate 15 random numbers based on normal distribution

1:10 %>% # iterates 10 times
  map(rnorm, n = 15) %>% # calculates  15 random numbers based on normal distribution
  map_dbl(mean) # calculates mean (double)

# Note: you can put your own functions in here

1:10 %>% # iterates 10 times
  map(function(x) rnorm(15, x)) %>% # make your own function
  map_dbl(mean)

# Use a formula when you want to change the arguments within the function
1:10 %>%
  map(~ rnorm(15, .x)) %>% # changes the arguments inside the function
  map_dbl(mean)

### bring in files using purr instead of for loop----

# point to the location on the computer of the folder
CondPath<-here("Week_12", "data", "cond_data")
# list all files that have .csv in file path
files <- dir(path = CondPath,pattern = ".csv")
files

# or

# we can get the full file names (path) by doing this...
files <- dir(path = CondPath,pattern = ".csv", full.names = TRUE)
#save the entire path name
files

# read in files
data<-files %>%
  set_names()%>% # sets the id of each list to the file name
  map_df(read_csv,.id = "filename") # map everything to a dataframe and put the id in a column called filename
data
# note: you can change column name using what we learned from strings

# calculate means
data<-files %>%
  set_names()%>% # set's the id of each list to the file name
  map_df(read_csv,.id = "filename") %>% # map everything to a dataframe and put the id in a column called filename
  group_by(filename) %>%
  summarise(mean_temp = mean(Temperature, na.rm = TRUE),
            mean_sal = mean(Salinity,na.rm = TRUE))
data

