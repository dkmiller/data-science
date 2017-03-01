# Chapter 13 from "R for data science"
# http://r4ds.had.co.nz/relational-data.html

library(fueleconomy)
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
weather.data <- flights %>%
  left_join(weather) %>%
  filter(wind_speed < 1000) %>%
  select(dep_delay, temp, dewp, humid, wind_speed, wind_gust, precip, pressure, visib)

# Seems like no real correlations here.
cor(scale(weather.data), use="complete")

# Visibility doesn't seem to affect anything. 
weather.data %>%
  filter(!is.na(visib) & !is.na(dep_delay)) %>%
  filter(dep_delay > 100) %>%
  ggvis(~factor(visib), ~dep_delay) %>%
  layer_boxplots()

# More helpful, perhaps. Try with temp, dewp, humid, wind_speed, wind_gust, precip, pressure, visib. 
weather.data %>%
  filter(dep_delay > 60) %>% # Only serious delays
  ggvis(~visib) %>%
  layer_histograms()

# It seems like for humidity > 80, there are more delays
# Ditto for wind_speed > 30
# ... for wind_gust > 40
# ... for visib < 4

# 5. What happened on June 13 2013? 
# Seems to be a lot of delays on the East Coast. There were two derechos 
# https://en.wikipedia.org/wiki/June_12%E2%80%9313,_2013_derecho_series
flights %>%
  left_join(weather) %>%
  filter(year == 2013 & month == 6 & day == 13) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  ggplot(aes(lon,lat, size = arr_delay + dep_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()





# 13.5.1 Exercises

# 1. What does it mean for a flight to have a missing tailnum?
# It means the flight was cancelled. 
flights %>%
  filter(is.na(tailnum))

# What do the tail numbers that don???t have a matching record in planes have in common?
# All but a few are from AA or MQ. 
flights %>%
  anti_join(planes, by = "tailnum") %>%
  filter(!is.na(tailnum)) %>%
  group_by(carrier) %>%
  summarise(count = n())

#2. Filter flights to only show flights with planes that have flown at least 100 flights.
flights %>%
  group_by(tailnum) %>%
  summarise(count = n(), sort = T) %>%
  filter(count >= 100)

# Combine fueleconomy::vehicles and fueleconomy::common 
# to find only the records for the most common models.
fueleconomy::common %>%
  left_join(fueleconomy::vehicles)



