#### General Info ####-------------------------------------------------------
#
# This script is an introduction to using factors in R
#
# created: 2023-04-20
# created by: Marisa Mackie

#### Libraries ####----------------------------------------------------------
library(tidyverse) # using forcats package
library(here)

#### Data ####---------------------------------------------------------------
income_mean <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_mean.csv')


### Intro to Factors ----
# Factor = a special version of a character
# How we store categorical data
# Levels = values that factors take; how we order our data
# default levels = alphabetical
# When you convert a character into a factor, R stores them as integers (1,2,3,..n)

# assigns a factor
fruits <- factor(c("Apple", "Grape", "Banana"))
fruits # notice it alphabetizes them

# factor booby-traps
# Let's say you had a typo in a column of what was suppose to be numbers. 
# R will read everything in as characters. 
# If they are characters and you try to covert it to a number, 
# the rows with real characters will covert to NAs

# thus, read in data with read_csv, not read.csv
# read_csv converts data to strings, read.csv converts to factors automatically.
# YOU want to be th eone to assign your data to factors

test<-c("A", "1", "2")
as.numeric(test)

#### Analysis ####--------------------------------------------------------

# starwars data
glimpse(starwars)

# Uses fct_lump() to lump together stuff into one, and assigns everything to a factor
star_counts<-starwars %>%
  filter(!is.na(species)) %>% # removes NAs
  mutate(species = fct_lump(species, n = 3)) %>% # lumps together any species that has less than 3 individuals into "Other"
  count(species)

star_counts

# plots it
star_counts %>%
  ggplot(aes(x = species, y = n))+
  geom_col()

# re-orders species in ascending order
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n), y = n))+ # reorder the factor of species by n
  geom_col()

# re-orders in descending order
star_counts %>%
  ggplot(aes(x = fct_reorder(species, n, .desc = TRUE), y = n))+ # reorder the factor of species by n
  geom_col()

###----

glimpse(income_mean)

# We will make a plot of the total income by year and quintile across all dollar types.
total_income<-income_mean %>%
  group_by(year, income_quintile)%>%
  summarise(income_dollars_sum = sum(income_dollars))%>%
  mutate(income_quintile = factor(income_quintile)) # make it a factor

view(total_income)

# plot
# use fct_reorder2 (by two things)
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, 
             color = fct_reorder2(income_quintile, year,income_dollars_sum)))+
  geom_line()

# reordering stuff in a vector directly
# out of order:
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"))
x1

# in order:
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"), levels = c("Jan", "Mar", "Apr", "Dec"))
x1

# subset data with factors
# instead of grouping <3 counts species into "other," we can filter them out
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) # only keep species that have more than 3
starwars_clean

levels(starwars_clean$species) # still there

# note: all levels are still there, they're just hidden. You must drop it to actually get rid of it
# use fct_drop() or droplevels()

starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() # drop extra levels

levels(starwars_clean$species) # filtered levels are dropped

# We can recode (rename) levels
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor 
  filter(n>3)  %>% # only keep species that have more than 3 
  droplevels() %>% # drop extra levels
  mutate(species = fct_recode(species, "Humanoid" = "Human")) # renames the factor. works like an assignment statement: new name = old name


