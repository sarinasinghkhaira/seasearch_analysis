library(tidyverse)
library(janitor)
library(here)

#read in survey observations
seasearch <- read_csv(here("raw_data/records-2021-02-09.csv"))

#read in data dictionary
data_dict <- read_csv(here("raw_data/headings.csv"))

#### Drop all variables with a single distinct value (this includes variables with all missing values)
vars_to_drop <- seasearch %>% 
  summarise_all(n_distinct) %>%
  pivot_longer(cols = everything()) %>%
  filter(value == 1) %>%
  pull(name)

seasearch_cleaned <- seasearch %>%
  select(-all_of(vars_to_drop)) %>%
  clean_names()

#refine data dictionary to only include variables to keep
refined_data_dict <- data_dict %>%
  filter(!`Column name` %in% vars_to_drop)



#export as csv into clean_data