##### General Info #####

##### Load Libraries #####
library(tidyverse)
library(palmerpenguins)
library(PNWColors)

##### Data #####

###------ Why use functions?

# create dataframe of random numbers
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# Rescale every column individually
df <- df %>% 
  mutate(a = (a-min(a,na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a,na.rm = TRUE)),
         b = (b-min(b,na.rm = TRUE))/(max(b, na.rm = TRUE)-min(b,na.rm = TRUE)),
         c = (c-min(c,na.rm = TRUE))/(max(c, na.rm = TRUE)-min(c,na.rm = TRUE)),
         d = (d-min(a,na.rm = TRUE))/(max(d, na.rm = TRUE)-min(d,na.rm = TRUE)))

view(df)

# Note: Doing this by hand is very conducive to mistakes. We can make it a function.

###-------- How to make a Function:

# Example: Fahrenheit to Celsius function
# R code:
temp_C <- (temp_F - 32) * 5 / 9

# function:
# Step 1: Name fxn
tempF_to_C <- function() {}
# Step 2: Put in equation
tempF_to_C <- function() {temp_C <- (temp_F - 32) * 5 / 9}
# Step 3: Input arguments
tempF_to_C <- function(temp_F) {temp_C <- (temp_F - 32) * 5 / 9}
# Step 4: Decide what is being returned
tempF_to_C <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)}
# Step 5: Test it, make sure it works!
tempF_to_C(32)

# Challenge: make a Celsius to Kelvin function
tempC_to_K <- function(temp_C) {
  temp_K <- (temp_C + 273.15)
  return(temp_K)}
# Test:
tempC_to_K(0)

###---------- Making plots into a function

# plot function w penguins and using palette
# R code:
pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
  geom_point()+
  geom_smooth(method = "lm")+ # add a linear model
  scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
  theme_bw()

# Function:
# NOTE!!! Need to use curly-curly {{}} in function to call the column name from a dataset
myplot <- function(data, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
  }

# test it!
myplot(data = penguins, x = body_mass_g, y = bill_length_mm)

# You can create defaults within your function arguments:
# Example: set data = penguins so the function knows the data is always the penguin dataset
myplot <- function(data, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete")
  ggplot(data = penguins, aes(x = {{x}}, y = {{y}} , color = island))+ # default: data = penguins
    geom_point()+
    geom_smooth(method = "lm")+
    scale_color_manual("Island", values=pal)+
    theme_bw()
}
# Test
myplot(x = body_mass_g, y = flipper_length_mm)

# NOTE: You can overwrite the defaults by specifying in your arguments when using fxn
# Example:
myplot(x = SomeOtherDataHere, body_mass_g, y = flipper_length_mm)

# You can also layer onto your plot using '+' just like it is a regular ggplot to change things like labels.

myplot(x = body_mass_g, y = flipper_length_mm)+
  labs(x = "Body mass (g)",
       y = "Flipper length (mm)")

###------- If-else statements:

# Add if-else statements for flexibility. SImple example:
a <- 4
b <- 5

if (a > b) { # my question
  f <- 20 # if it is true give me answer 1
} else { # else give me answer 2
  f <- 10
}

# If we want/don't want lines, we can use if_else logical in our fxn
myplot<-function(data = penguins, x, y, lines=TRUE ){ # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  if(lines==TRUE){
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      geom_smooth(method = "lm")+ # add a linear model
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
  else{
    ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
}

# Test it: With lines (Default: lines = TRUE)
myplot(x = body_mass_g, y = flipper_length_mm)

# Test it: Without lines
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)


# Notes:
# Functions should be FLEXIBLE. Should be able to apply it to different datasets.