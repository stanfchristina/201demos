# Cheatsheets!!

# Set working directory
# Load dpylr library
library(dplyr)
library(lintr)
library(styler)

# PART 1: LOADING AND EXPLORING DATA
# Practice writing functions and using standard dataframe methods.

# You'll want to get your data from the kaggle website and store
# the csv into a data/ folder, but I'll use a different dataset
# for this demo.
airbnb_data <- read.csv("data/listings.csv", stringsAsFactors = FALSE)
glimpse(airbnb_data)

# This section is mostly review, a couple important functions unique() and typeof() and pull()
airbnb_names <- airbnb_data %>% pull(name)
airbnb_prices <- airbnb_data %>% pull(price)
typeof(airbnb_names)
typeof(airbnb_prices)
is.numeric(airbnb_prices)
is.numeric(airbnb_names)

# remember we can get a vector of the unique values in a column with unique()
unique(airbnb_data$neighbourhood)
# can chain with methods like length() to get number of unique
length(unique(airbnb_data$neighbourhood))

# PART 2: ASKING QUESTIONS ABOUT THE DATA

# Using the pipe operator makes things really intuitive.
# Chaining logical operations/steps that lead to my solution.

# Making a sandwich example (write on the board)
# slices <- Cut(object = bread)
# smeared <- Smear(object = slices, condiment = 'peanut_butter')
# pickled <- Apply(object = smeared, what = 'pickles', method = 'carefully')
# sandwich <- Close(object = pickled)
#
# sandwich <-
#   bread %>%
#   Cut() %>%
#   Smear(condiment = 'peanut_butter') %>%
#   Apply(what = 'pickles', method = 'carefully') %>%
#   Close()
  
# filter()
# Filters data by removing rows that don't match the criteria you specify.

# Name of the most expensive AirBnb in the UDistrict?
airbnb_data %>%
  filter(neighbourhood == "University District") %>%
  filter(price == max(price)) %>%
  pull(name)

# How many AirBnBs in the UDistrict had their last review in 2017?
airbnb_data %>%
  filter(neighbourhood == "University District") %>%
  filter(format(as.Date(last_review), "%Y") == 2017) %>%
  nrow()

# summarise()
# Creates a table of summaries about statistics you specify (e.g. averages, totals).

# What is the average price of renting a private room in Seattle?
airbnb_data %>%
  filter(room_type == "Private room") %>%
  summarise(avg_price = mean(price)) %>%
  pull(avg_price)

# How many total reviews have been written about AirBnbs in the UDistrict?
airbnb_data %>%
  filter(neighbourhood == "University District") %>%
  summarise(total_reviews = sum(number_of_reviews)) %>%
  pull(total_reviews)

# PART 3: ANALYSIS WITH "GROUPED" OBSERVATIONS

# groupby()
# Create "grouped" copy of the table, very useful for manipulating groups separately.
# Often followed by summarise()

# Which neighbourhood has the most total reviews?
airbnb_data %>%
  group_by(neighbourhood) %>%
  summarise(total_reviews = sum(number_of_reviews)) %>%
  filter(total_reviews == max(total_reviews)) %>%
  pull(neighbourhood)

# What are the top 5 priciest neighbourhoods?
airbnb_data %>%
  group_by(neighbourhood) %>%
  summarise(avg_price = mean(price)) %>%
  top_n(n = 5, wt = avg_price) %>%
  pull(neighbourhood)

# mutate()
# Compute a new column.

# What day of the week was the most common for last reviews?
airbnb_data %>%
  mutate(day = weekdays(as.Date(last_review))) %>%
  group_by(day) %>%
  summarise(day_count = n()) %>%
  filter(day_count == max(day_count)) %>%
  pull(day)

# Which year had the most "last reviews" submitted?
airbnb_data %>%
  mutate(year = format(as.Date(last_review), "%Y")) %>%
  group_by(year) %>%
  summarise(year_count = n()) %>%
  filter(year_count == max(year_count)) %>%
  pull(year)

# Run style and lint on the file
