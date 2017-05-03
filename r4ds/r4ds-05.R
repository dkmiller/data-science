library(ggvis)
library(nycflights13)
library(tidyverse)

# Problems from chapter 5 of the book "R for data science"
# http://r4ds.had.co.nz/transform.html





# 5.2.4 Exercises

# 1. All flights such that...

# Arrival delay of more than two hours.
flights %>%
  filter(arr_delay > 120)

# Flew to Houston (IAH or HOU).
flights %>%
  filter(dest %in% c("IAH", "HOU"))

# Were operated by United, American, or Delta.
airlines %>%
  filter(grepl("American|Delta|United", name)) %>%
  select(carrier) %>%
  inner_join(flights)

# Departed in summer (July, August, and September).
flights %>%
  filter(month %in% c(7,8,9))

# Arrived more than two hours late, but didn't leave late.
flights %>%
  filter(arr_delay > 120, dep_delay <= 0)

# Were delayed by at least an hour, but made up over 30 minutes in flight.
flights %>%
  filter(dep_delay >= 60, arr_delay < dep_delay-30)

# Departed between midnight and 6am (inclusive).
flights %>%
  filter(between(hour, 0, 5) | (hour == 6 & minute == 0))

# 2. between(x,a,b) is equivalent to (a <= x & x <= b).

# 3. There are 8255 flights with no departure time. These are cancelled flights. 
flights %>%
  filter(is.na(dep_time)) %>%
  summarise(n = n())





# 5.3.1 Exercises

# 1. 
flights %>%
  arrange(desc(is.na(dep_time)))

# 2. Sort flights to find the most delayed flights. 
flights %>%
  arrange(desc(arr_delay))
# Find the flights that left earliest.
flights %>%
  arrange(dep_delay)

# 3. Sort flights to find the fastest flights.
flights %>%
  arrange(air_time)

# Which flights travelled the longest? 
flights %>%
  arrange(desc(distance))
#Which travelled the shortest?
flights %>%
  arrange(distance)





# 5.4.1 Exercises

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, 
# arr_time, and arr_delay from flights.
flights %>%
  select(dep_time, dep_delay, arr_time, arr_delay)
flights %>%
  select(matches("^(dep|arr)_(time|delay)"))

# 2. Selecting the same variable multiple times results in repeated instances
# being ignored. 
flights %>%
  select(carrier, dep_time, carrier)

# 3. Use of "one_of".
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
flights %>%
  select(one_of(vars))

# 4. contains ignores case by default. Here is a case-sensitive version.
flights %>%
  select(contains("TIME", ignore.case = FALSE))





# 5.5.2 Exercises

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard 
# to compute with because they're not really continuous numbers. Convert them 
# to a more convenient representation of number of minutes since midnight.
flights %>%
  mutate(dep_time_minutes = 60 * (dep_time %/% 100) + (dep_time %% 100)) 

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? 
# What do you see? What do you need to do to fix it?
flights %>%
  ggvis(~air_time, ~arr_time - ~dep_time) %>%
  layer_points()





# 5.6.7 Exercises

# 1. Fundamentally, the "delay characteristics" of a group of flights is 
# characterized by the histogram of arrival delay. Departure delay is 
# inconsiquential: as long as a flight arrives on time, it doesn't matter if 
# it departed late. 
flights %>%
  filter(arr_delay < 300) %>%
  ggvis(~arr_delay) %>%
  layer_histograms()
# Five different metrics of flight delay:
# Median delay.
flights %>%
  summarise(median_delay = median(arr_delay, na.rm = T))
# Percentage of flights that are at least 30min late.
mean(flights$arr_delay > 30, na.rm = T)
# 95% quantile of arrival delay
quantile(flights$arr_delay, 0.95, na.rm = T)





# 5.7.1 Exercises

# 2. Which plane has the worst on-time record?
# The plane N844MH has worst median arrival delay. 
flights %>%
  group_by(tailnum) %>%
  summarise(delay = median(arr_delay)) %>%
  arrange(desc(delay))

# 3. What time of day should you fly if you want to avoid delays as much as possible?
# Only considering late flights, the departure hour with lowest median delay is 
# 5 am. 
flights %>%
  filter(arr_delay > 0) %>%
  group_by(hour) %>%
  summarise(avg_delay = median(arr_delay, na.rm = T)) %>%
  arrange(avg_delay)
