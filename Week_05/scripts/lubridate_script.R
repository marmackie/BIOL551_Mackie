###### General Info ######-----------------------------------------------------
# This script will serve as practice for using the Lubridate package to lubridate
# dates & times
#
# created: 2023-02-23
# created by: Marisa Mackie
# edited: 2023-02-23

###### Load Libraries ######---------------------------------------------------
library(tidyverse)
library(here)
library(lubridate)

###### Data ######-------------------------------------------------------------
CondData <- read_csv(here("Week_05","data","CondData.csv")) %>% 
  mutate(date = mdy_hm(Date))

view(CondData)

DepthData <- read_csv(here("Week_05", "data","DepthData.csv")) %>% 
  mutate()

view(DepthData)

###### Analysis ######---------------------------------------------------------

now() # gives time & date of today in your timezone

now(tzone = "EST") # gives time & date of today in specified timezone (e.g. EST)

today() # gives date of today in your timezone

today(tzone = "EST") # gives date of today in specified timezone (e.g. EST)

am(now()) # logical: asks is it morning (am) now?

leap_year(now()) # logical: asks is it a leap year?

# Below are diff ways to convert dates in different formats to YYYY-MM-DD format
# NOTE: Dates MUST be characters; not factors
ymd("2021-02-24") # year/month/day becomes YYYY-MM-DD
mdy("02/24/2021") # month/day/year becomes YYYY-MM-DD
mdy("February 24 2021")
dmy("24/02/2021") # day/month/year becomes YYYY-MM-DD
ymd_hms("2021-02-24 10:22:20 PM") #hms = hour/min/sec
ymd_hm("2021-02-24 10:22 PM") #hm = hour/min

# vector of a bunch of dates
datetimes <- c("02/24/2021 22:22:20",
               "02/25/2021 11:21:10",
               "02/26/2021 8:01:52")

# converts datetimes (char) to date format 
# (data type in ENvironment will say POSIXct)
datetimes <- mdy_hms(datetimes)

#
month()



