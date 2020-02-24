#Cleaning Script for Powerlifting Package
#
library(tidyverse)

setwd("C:/Users/ASUS/Documents/Data and Analytics/")

df <- read.csv('ipf_lifts.csv')

df_clean <- df %>% 
  janitor::clean_names()

df_clean %>% 
  group_by(federation) %>% 
  count(sort = TRUE)

size_df <- df_clean %>% 
  select(name:weight_class_kg, starts_with("best"), place, date, federation, meet_name)  %>% 
  filter(!is.na(date)) %>% 
  filter(federation == "IPF") %>% 
  object.size()

ipf_data <- df_clean %>% 
  select(name:weight_class_kg, starts_with("best"), place, date, federation, meet_name)  %>% 
  filter(!is.na(date)) %>% 
  filter(federation == "IPF")

print(size_df, units = "MB")

ipf_data %>% 
  write_csv(here::here("2019", "2019-10-08","ipf_lifts.csv"))