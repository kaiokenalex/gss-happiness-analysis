# Setup
library(gssr)
library(tidyverse)
library(haven)
library(lmtest)
library(sandwich)
library(skimr)

options(scipen = 999) # turn off scientific notation

# load the gss data frame (it's big and will take a minute to load)
data(gss_all)


gss_select <- gss_all %>%
  dplyr::select(age, educ, race, sex, year, happy, wrkslf, hrs1, realrinc) %>%   # add your variables
  mutate(across(everything(), zap_missing)) # Convert all missing codes to NA

# clean up variables
# convert race to factor
gss_race_factor <- gss_select %>%
  mutate(race = as_factor(race))

# indicator levels for race
gss_race_clean <- gss_race_factor %>%
  mutate(race_white = if_else(race == "white", 1, 0)) %>%
  mutate(race_black = if_else(race == "black", 1, 0))

# sex
gss_sex_factor <- gss_race_clean %>% # start with the data frame that cleaned race
  mutate(sex = as_factor(sex))

# indicator levels for sex
gss_sex_clean <- gss_sex_factor %>%
  mutate(sex_male = if_else(sex == "male", 1, 0)) %>%
  mutate(sex_female = if_else(sex == "female", 1, 0))

# wrkslf
gss_wrkslf_factor <- gss_sex_clean %>%
  mutate(wrkslf = as_factor(wrkslf))

# indicator levels for wrkslf
gss_wrkslf_clean <- gss_wrkslf_factor %>%
  mutate(
    self_employed = if_else(wrkslf == "self-employed", 1, 0),
    someone_else = if_else(wrkslf == "someone else", 1, 0)
  )

# hrs1
gss_hrs1_clean <- gss_wrkslf_clean %>%
  mutate(hrs1 = as.numeric(hrs1)) %>%
  # high values might represent something else than hours worked
  mutate(hrs1 = if_else(hrs1 > 89, NA_real_, hrs1)) %>%
  # indicator
  mutate(fulltime_overtime = if_else(hrs1 >= 40, 1, 0))

# happy
gss_happy_factor <- gss_hrs1_clean %>%
  mutate(happy = as_factor(happy))

# indicator for happy
gss_happy_clean <- gss_happy_factor %>%
  mutate(is_very_happy = if_else(happy == "very happy", 1, 0))

# realrinc indicator
gss_realrinc_clean <- gss_happy_clean %>%
  mutate(low_inc = if_else(realrinc < 25000, 1, 0)) %>%
  mutate(median_inc = if_else(realrinc >= 25000 & realrinc <= 75000, 1, 0)) %>%
  mutate(high_inc = if_else(realrinc > 75000, 1, 0))

# summary tables
# remove observations with missing data, zap labels
gss_final <- gss_realrinc_clean %>%
  mutate(across(everything(), zap_labels)) %>%
  drop_na()

# use skim() to generate a summary statistics table
skim(gss_final)
