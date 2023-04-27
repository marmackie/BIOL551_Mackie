#### General Info ####------------------------------------
#
# Intro to models
#
# created: 2023-27-04
# created by: Marisa Mackie

#### Load Libraries ####----------------------------------
library(tidyverse)
library(here)
library(palmerpenguins)
library(modelsummary)
library(tidymodels)
library(broom)
library(flextable)
library(performance)

#### Intro to Models ####----------------------------------

## WARNING: Please make sure you understand the theory behind the statistics that you are using before you use them. 
## Also, even though we spent the semester learning about cleaning and visualization you MUST use stats to interpret your data.

# To run a simple linear model you use the following formula:
mod <- lm(y~x, data = df)
# lm = linear model
# y = dependent variable
# x = independent variable(s)
# df = dataframe

# You read this as "y is a function of x" (? might be backwards)

# Multiple regression
mod<-lm(y~x1 + x2, data = df)

# Interaction term
mod<-lm(y~x1*x2, data = df) 
# note: the * will compute x1+x2+x1:x2

# Linear model of Bill depth ~ Bill length by species
Peng_mod<-lm(bill_length_mm ~ bill_depth_mm*species, data = penguins)

## NOTE: ALWAYS check the assumptions of your specific model. 
# Make sure you know what your model is doing behind the scenes and that you meet all assumptions before interpreting your results. 
# The {performance} package makes this super easy.
check_model(Peng_mod) # check assumptions of an lm model

## Viewing results----

# ANOVA
anova(Peng_mod)

# Coefficients (effect size) with error
summary(Peng_mod)

# Use broom we can "tidy" the results so that it is easier to view and extract. Functions tidy(), glance(), and augment() will clean up your results
# Tidy coefficients
coeffs<-tidy(Peng_mod) # just put tidy() around it
coeffs

# glance extracts R-squared, AICs, etc of the model
# tidy r2, etc
results<-glance(Peng_mod) 
results

# augment adds residuals and predicted values to your original data and requires that you put both the model and data
# tidy residuals, etc
resid_fitted<-augment(Peng_mod)
resid_fitted

## modelsummary: creates tables and plots to summarize statistical models and data in R.
## Functions:
# modelsummary: Regression tables with side-by-side models.
# modelsummary_wide: Regression tables for categorical response models or grouped coefficients.
# modelplot: Coefficient plots.
# datasummary: Powerful tool to create (multi-level) cross-tabs and data summaries.
# datasummary_balance: Balance tables with subgroup statistics and difference in means (aka “Table 1”).
# datasummary_correlation: Correlation tables.
# datasummary_skim: Quick overview (“skim”) of a dataset.
# datasummary_df: Turn dataframes into nice tables with titles, notes, etc.


# Let's compare the Peng_mod with one that does not have species as an interaction term.

# New model
Peng_mod_noX<-lm(bill_length_mm ~ bill_depth_mm, data = penguins)
#Make a list of models and name them
models<-list("Model with interaction" = Peng_mod,
             "Model with no interaction" = Peng_mod_noX)
#Save the results as a .docx
modelsummary(models, output = here("Week_12","output","table.docx"))

# Modelplot
modelplot(models) +
  labs(x = 'Coefficients', 
       y = 'Term names')

### Many models:
# Lists allows you to have uneven sets (as opposed to a dataframe)
# LISTS ARE SUPER IMPORTANT FOR ITERATING

# We can essentially make a set of lists that have each dataset that we want to model and use the map functions to run the same model to every dataset.

# First, let's call the penguin data and create a list for the data by each species. We do this using nest(). We are going to nest the data by species.
models<- penguins %>%
  ungroup()%>% # the penguin data are grouped so we need to ungroup them
  nest(-species) # nest all the data by species
models

# map a model to each of the groups in the list
models<- penguins %>%
  ungroup()%>% # the penguin data are grouped so we need to ungroup them
  nest(-species) %>% # nest all the data by species 
  mutate(fit = map(data, ~lm(bill_length_mm~body_mass_g, data = .)))
models

# view results
results<-models %>%
  mutate(coeffs = map(fit, tidy), # look at the coefficients
         modelresults = map(fit, glance))  # R2 and others
results

# select what we want to show and unnest it to bring it back to a dataframe
results<-models %>%
  mutate(coeffs = map(fit, tidy), # look at the coefficients
         modelresults = map(fit, glance)) %>% # R2 and others 
  select(species, coeffs, modelresults) %>% # only keep the results
  unnest() # put it back in a dataframe and specify which columns to unnest
view(results) # view the results

### Other stats packages:------
# stats: General (lm)and generalized (glm) linear models (already loaded with base R)
# lmer : mixed effects models
# lmerTest' : getting results from lmer
# nlme : non-linear mixed effects models
# mgcv, gam : generalized additive models
# brms, rstan, and many more : Bayesian modeling
# lavaan, peicewiseSEM : Structural Equation Models
# rpart, randomForest, xgboost, and more : Machine learning models


#### Tidy Models ####-----------------------------------------------
# In tidymodels you start by specifying the functional form using the parsnip package. 
# In our case, we will use a linear regression which is coded like this:
linear_reg()

# Next, we need to set the engine for what type of linear regression we are modeling. 
# e.g., we could use an OLS regression or Bayesian or several other options. 
# We will stick with OLS.
lm_mod<-linear_reg() %>%
  set_engine("lm")
lm_mod

# Next, we add the model fit.
lm_mod<-linear_reg() %>%
  set_engine("lm") %>%
  fit(bill_length_mm ~ bill_depth_mm*species, data = penguins)
lm_mod

# after tidying and piping to a plot
lm_mod<-linear_reg() %>%
  set_engine("lm") %>%
  fit(bill_length_mm ~ bill_depth_mm*species, data = penguins) %>%
  tidy() %>%
  ggplot()+
  geom_point(aes(x = term, y = estimate))+
  geom_errorbar(aes(x = term, ymin = estimate-std.error,
                    ymax = estimate+std.error), width = 0.1 )+
  coord_flip()
lm_mod

