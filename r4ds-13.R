# Chapter 13 from "R for data science"
# http://r4ds.had.co.nz/relational-data.html

library(ggvis)
library(tidyverse)
library(maps)
library(nycflights13)

# Some useful tibbles:
airlines # code -> full name
airports # code -> full name + location
planes   # tailnum -> all info
weather  # weather at each airport





# 13.2.1 Exercises

# 1. To draw the route each plane flies from origin to destination, I'd need 
# the year, month, day, flight number. Then for each flight, I could look up 
# the geographic data for the corresponding origin and destination airports. 

# 2. Weather relates to airports as: each "origin" points to a unique airport code.





# 13.3.1 Exercises

# 1. Add a surragate key (unique identifier) to flights
flights <- flights %>%
  mutate(surr_key = row_number())

# 2. 
# key(Lahman::Batting) = (playerID, yearID)
# key(babynames::babynames) = (year, sex, name)
# key(nasaweather::atmos) = (lat, long, year, month)
# key(fueleconomy::vehicles) = id
# key(ggplot2::diamonds) = row number! (no keys)





# 13.4.6 Exercises

# 1. 
flights %>% 
  group_by(dest) %>% 
  summarise(avg.delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  ggplot(aes(lon,lat, color = avg.delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2. Add the location of the origin and destination (i.e. the lat and lon) to flights.
airports %>%
  select(faa, dest.lat = lat, dest.lon = lon) %>%
  right_join(flights, by = c("faa" = "dest")) %>%
  left_join(select(airports, faa, arr.lat = lat, arr.lon = lon), by = c("origin" = "faa"))

# 3. Is there a relationship between the age of a plane and its delays?
# It doesn't look like it! (Up until the year 2000, after which newer planes definitely have fewer 
# delays).
flights %>%
  group_by(tailnum) %>%
  summarise(avg.del = mean(arr_delay, na.rm = T)) %>%
  left_join(planes) %>%
  select(avg.del, year) %>%
  group_by(year) %>%
  summarise(avg.delay = mean(avg.del,  na.rm = T)) %>%
  ggvis(~year, ~avg.delay) %>%
  layer_points()

# 4. What weather conditions make it more likely to see a delay?
# WARNING: this crashes RStudio.
flights %>%
  left_join(weather) %>%
  filter(wind_speed < 100)
  ggvis(~wind_speed, ~dep_delay) %>%
  layer_model_predictions(model = "lm", se = TRUE)

